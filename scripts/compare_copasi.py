"""Compare the unchanged source SBML in COPASI with the Python baseline.

COPASI is optional. This script configures only the imported native task and
report; it never rewrites the source SBML or the committed benchmark outputs.
"""
from __future__ import annotations

import argparse
import csv
import hashlib
import importlib.metadata
import json
import os
from pathlib import Path
import subprocess
import sys
import xml.etree.ElementTree as ET

import numpy as np

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
from mapk_lab.model import GROUPS, SPECIES, TOTALS, load_model  # noqa: E402

NS = "{http://www.copasi.org/static/schema}"
MAX_ABSOLUTE_ERROR = 0.002  # Same absolute concentration criterion as existing solver checks.


def digest(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def invoke(executable, *arguments):
    result = subprocess.run([str(executable), *map(str, arguments)], capture_output=True,
                            text=True, encoding="utf-8", errors="replace", timeout=90,
                            creationflags=getattr(subprocess, "CREATE_NO_WINDOW", 0))
    if result.returncode:
        raise ValueError(f"COPASI exited {result.returncode}: {result.stderr.strip()}")
    return result.stdout.strip(), result.stderr.strip()


def configure_native(path, times):
    tree = ET.parse(path)
    root = tree.getroot()
    model = root.find(NS + "Model")
    model_name = model.attrib["name"]
    compartments = {c.attrib['key']: c.attrib['name'] for c in model.findall(f"{NS}ListOfCompartments/{NS}Compartment")}
    metabolites = {m.attrib['key']: m for m in model.findall(f"{NS}ListOfMetabolites/{NS}Metabolite")}
    mapping = {m.attrib['SBMLid']: m.attrib['COPASIkey'] for m in root.findall(f"{NS}SBMLReference/{NS}SBMLMap")}
    task = root.find(f"{NS}ListOfTasks/{NS}Task[@type='timeCourse']")
    if task is None or set(SPECIES) - mapping.keys():
        raise ValueError("COPASI import did not retain the expected species mapping or time-course task")
    for other in root.findall(f"{NS}ListOfTasks/{NS}Task"):
        other.set('scheduled', 'false')
    task.set('scheduled', 'true')
    settings = {'AutomaticStepSize': '0', 'StepNumber': str(len(times) - 1),
                'StepSize': str(times[1] - times[0]), 'Duration': str(times[-1]),
                'TimeSeriesRequested': '1', 'OutputStartTime': '0',
                'Start in Steady State': '0', 'Use Values': '0'}
    for parameter in task.findall(f"{NS}Problem/{NS}Parameter"):
        if parameter.get('name') in settings:
            parameter.set('value', settings[parameter.get('name')])
    method = task.find(NS + 'Method')
    if method.get('type') != 'Deterministic(LSODA)':
        raise ValueError("Expected COPASI deterministic LSODA method")
    for parameter in method.findall(NS + 'Parameter'):
        if parameter.get('name') in ('Relative Tolerance', 'Absolute Tolerance'):
            parameter.set('value', '1e-10' if parameter.get('name') == 'Relative Tolerance' else '1e-12')
    report = task.find(NS + 'Report')
    report.set('reference', 'Report_cross_engine')
    report.set('target', 'copasi-trajectory.tsv')
    report.set('append', '0')
    report.set('confirmOverwrite', '0')
    definition = ET.SubElement(root.find(NS + 'ListOfReports'), NS + 'Report',
        key='Report_cross_engine', name='Concentrations in SBML identifier order',
        taskType='timeCourse', separator='\t', precision='16')
    table = ET.SubElement(definition, NS + 'Table', printTitle='1')
    ET.SubElement(table, NS + 'Object', cn=f'CN=Root,Model={model_name},Reference=Time')
    for species in SPECIES:
        metabolite = metabolites[mapping[species]]
        compartment = compartments[metabolite.attrib['compartment']]
        cn = f'CN=Root,Model={model_name},Vector=Compartments[{compartment}],Vector=Metabolites[{metabolite.attrib["name"]}],Reference=Concentration'
        ET.SubElement(table, NS + 'Object', cn=cn)
    root.find(NS + 'SBMLReference').set('file', Path(os.path.relpath(ROOT / 'data/model.xml', path.parent)).as_posix())
    ET.register_namespace('', NS[1:-1])
    tree.write(path, encoding='utf-8', xml_declaration=True)


def compare_arrays(reference, candidate):
    if reference.shape != candidate.shape or reference.ndim != 2 or reference.shape[1] != 9:
        raise ValueError('Both trajectories must contain time and eight species in SBML identifier order')
    if not np.isfinite(reference).all() or not np.isfinite(candidate).all():
        raise ValueError('Trajectory values must be finite')
    if not np.allclose(candidate[:, 0], reference[:, 0], atol=1e-9, rtol=0):
        raise ValueError('Time grids disagree')
    values = candidate[:, 1:]
    error = np.abs(values - reference[:, 1:])
    conservation = max(float(np.max(np.abs(values[:, group].sum(axis=1) - total)))
                       for group, total in zip(GROUPS, TOTALS))
    maximum = float(error.max())
    checks = {'max_absolute_difference_nM': maximum,
              'absolute_tolerance_nM': MAX_ABSOLUTE_ERROR,
              'species_max_absolute_difference_nM': dict(zip(SPECIES, error.max(axis=0).tolist())),
              'conservation_max_absolute_difference_nM': conservation,
              'minimum_concentration_nM': float(values.min()),
              'initial_state_max_absolute_difference_nM': float(error[0].max())}
    checks['passed'] = bool(maximum <= MAX_ABSOLUTE_ERROR and conservation <= 1e-5
                           and values.min() >= -1e-7 and error[0].max() <= 1e-10)
    return checks


def compare(executable, out):
    out = Path(out).resolve()
    if out == ROOT or out.is_relative_to(ROOT / 'data') or out.is_relative_to(ROOT / 'results'):
        raise ValueError('Choose a new output directory outside source data and benchmark results')
    if out.exists():
        raise ValueError('Output directory already exists; choose a new directory to preserve prior files')
    model = load_model()  # Verify pinned source fingerprints before external import.
    times = np.linspace(0, 4000, 81)
    baseline = np.column_stack([times, model.simulate(times)])
    out.mkdir(parents=True)
    native = out / 'baseline.cps'
    version, _ = invoke(executable, '--version')
    _, import_warning = invoke(executable, '--nologo', '--importSBML', ROOT / 'data/model.xml', '--save', native)
    configure_native(native, times)
    _, run_warning = invoke(executable, '--nologo', '--report-file', out / 'copasi-trajectory.tsv', native)
    candidate = np.loadtxt(out / 'copasi-trajectory.tsv', delimiter='\t', skiprows=1)
    checks = compare_arrays(baseline, candidate)
    fields = ['time_seconds', 'species', 'python_nM', 'copasi_nM', 'difference_nM']
    with (out / 'comparison.csv').open('w', newline='', encoding='utf-8') as handle:
        writer = csv.writer(handle, lineterminator='\n')
        writer.writerow(fields)
        for i, time in enumerate(times):
            for j, species in enumerate(SPECIES, 1):
                writer.writerow([f'{time:g}', species, f'{baseline[i,j]:.16g}',
                                 f'{candidate[i,j]:.16g}', f'{candidate[i,j]-baseline[i,j]:.16g}'])
    import matplotlib
    matplotlib.use('Agg')
    import matplotlib.pyplot as plt
    fig, axes = plt.subplots(2, 1, figsize=(8.2, 6), constrained_layout=True, sharex=True)
    axes[0].plot(times, baseline[:, 8] / 300, color='#176b87', label='Python BDF')
    axes[0].plot(times, candidate[:, 8] / 300, color='#c25e28', linestyle='--', label='COPASI LSODA')
    axes[0].set(ylabel='MAPK-PP / total MAPK', title='Same SBML model, two simulation engines')
    axes[0].legend(frameon=False)
    for j, species in enumerate(SPECIES, 1):
        axes[1].plot(times, candidate[:, j] - baseline[:, j], label=species, linewidth=1)
    axes[1].axhline(0, color='#666666', linewidth=.6)
    axes[1].set(xlabel='Time (seconds)', ylabel='COPASI − Python (nM)',
                title=f'Maximum absolute difference: {checks["max_absolute_difference_nM"]:.3g} nM')
    axes[1].legend(ncol=4, fontsize=8, frameon=False)
    for ax in axes:
        ax.grid(alpha=.15)
        ax.spines[['top', 'right']].set_visible(False)
    fig.savefig(out / 'comparison.png', dpi=160)
    plt.close(fig)
    report = {'schema_version': 1, 'source_sbml_sha256': digest(ROOT / 'data/model.xml'),
              'script_sha256': digest(__file__), 'copasi_version': version.splitlines()[0],
              'python_versions': {name: importlib.metadata.version(name) for name in ('numpy','scipy','matplotlib')},
              'settings': {'v1_scale': 1, 'ki': 9, 'times_seconds': [0, 4000], 'time_points': 81,
                           'species_order': list(SPECIES), 'copasi_rtol': 1e-10, 'copasi_atol': 1e-12,
                           'python_method': 'BDF', 'python_rtol': 1e-8, 'python_atol': 1e-10},
              'checks': checks, 'warnings': [w for w in (import_warning,run_warning) if w],
              'scope': 'Baseline numerical agreement for the same pinned model; not biological validation or a test of the observation-selection policy.'}
    report['outputs_sha256'] = {p.name: digest(p) for p in (native,out/'comparison.csv',out/'comparison.png',out/'copasi-trajectory.tsv')}
    (out / 'verification.json').write_text(json.dumps(report, indent=2) + '\n', encoding='utf-8')
    return report


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--copasi', required=True, help='Path to the optional CopasiSE executable')
    parser.add_argument('--out', type=Path, default=ROOT / '.reproduction-copasi')
    args = parser.parse_args()
    try:
        report = compare(args.copasi, args.out)
        print(json.dumps(report['checks'], indent=2))
        raise SystemExit(0 if report['checks']['passed'] else 1)
    except (OSError, ValueError, subprocess.SubprocessError) as exc:
        print(f'Cross-engine comparison stopped: {exc}', file=sys.stderr)
        raise SystemExit(2)
