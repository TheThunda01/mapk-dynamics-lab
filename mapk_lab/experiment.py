"""Finite-grid Gaussian updating and deliberately separated acquisition/evaluation."""
import hashlib
import json
from pathlib import Path
import platform

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import scipy

from . import __version__
from .model import ROOT, SPECIES, load_model, numerical_checks

POLICIES = ("variance_guided", "random", "fixed")
BUDGETS = (0, 2, 4, 6, 8, 12)
READOUTS = ("MKK_PP_fraction", "MAPK_PP_fraction")
SIGMA = 0.04


def normalize_log_weights(log_weights):
    values = np.asarray(log_weights, dtype=float)
    if values.ndim != 1 or not len(values) or not np.isfinite(values).all():
        raise ValueError("Log weights must be a finite vector")
    weights = np.exp(values - values.max())
    return weights / weights.sum()


def update_weights(log_weights, predictions, observed, sigma):
    if not np.isfinite(sigma) or sigma <= 0 or not np.isfinite(observed):
        raise ValueError("Observation and positive noise scale must be finite")
    prediction = np.asarray(predictions, dtype=float)
    if prediction.shape != np.asarray(log_weights).shape or not np.isfinite(prediction).all():
        raise ValueError("Predictions and log weights must have the same finite shape")
    updated = np.asarray(log_weights) - 0.5 * ((observed - prediction) / sigma) ** 2
    return updated - updated.max()


def fixed_order(n_candidates, max_budget):
    if max_budget < 2 or max_budget > n_candidates:
        raise ValueError("Budget must be between two and candidate count")
    return [0, 1] + np.rint(np.linspace(2, n_candidates - 1, max_budget - 2)).astype(int).tolist()


def choose_candidate(policy, predictions, weights, selected, rng, max_budget=12):
    """Acquisition receives predictions/current weights, never hidden truth or outcomes."""
    predictions = np.asarray(predictions)
    weights = np.asarray(weights)
    if predictions.ndim != 2 or weights.shape != (predictions.shape[0],):
        raise ValueError("Invalid acquisition matrix or weights")
    if not np.isfinite(predictions).all() or not np.isfinite(weights).all() or np.any(weights < 0) or not np.isclose(weights.sum(), 1):
        raise ValueError("Acquisition requires finite predictions and normalized nonnegative weights")
    if len(set(selected)) != len(selected) or any(i < 0 or i >= predictions.shape[1] for i in selected):
        raise ValueError("Selected candidate IDs must be unique and valid")
    if policy not in POLICIES:
        raise ValueError("Unknown acquisition policy")
    if len(selected) >= max_budget:
        raise ValueError("Measurement budget already exhausted")
    if len(selected) < 2:
        return len(selected)
    available = np.setdiff1d(np.arange(predictions.shape[1]), selected)
    if not len(available):
        raise ValueError("No unobserved candidates remain")
    if policy == "fixed":
        return fixed_order(predictions.shape[1], max_budget)[len(selected)]
    if policy == "random":
        return int(rng.choice(available))
    means = weights @ predictions[:, available]
    variance = weights @ ((predictions[:, available] - means) ** 2)
    return int(available[np.argmax(variance)])


def run_policy(predictions, observed_pool, policy, sigma, random_seed, budgets=BUDGETS):
    """No truth index, noiseless truth curve, or future outcome reaches acquisition."""
    if tuple(budgets) != tuple(sorted(set(budgets))) or budgets[0] != 0 or budgets[-1] < 2:
        raise ValueError("Budgets must be increasing, unique, and begin at zero")
    if predictions.shape[1] < budgets[-1] or np.asarray(observed_pool).shape != (predictions.shape[1],):
        raise ValueError("Pool shape or budget is invalid")
    if not np.isfinite(observed_pool).all() or not np.isfinite(sigma) or sigma <= 0:
        raise ValueError("Pool and positive noise scale must be finite")
    log_weights = np.zeros(predictions.shape[0])
    snapshots = {0: normalize_log_weights(log_weights)}
    selected = []
    rng = np.random.default_rng(random_seed)
    for step in range(1, budgets[-1] + 1):
        candidate = choose_candidate(policy, predictions, normalize_log_weights(log_weights), selected, rng, budgets[-1])
        selected.append(candidate)
        log_weights = update_weights(log_weights, predictions[:, candidate], observed_pool[candidate], sigma)
        if step in budgets:
            snapshots[step] = normalize_log_weights(log_weights)
    return selected, snapshots


def metrics(weights, truth_id, parameters, evaluation):
    return truth_metrics(weights, parameters[truth_id], parameters, evaluation, evaluation[truth_id]) | {
        "true_hypothesis_mass": float(weights[truth_id])}


def truth_metrics(weights, truth_parameters, parameters, evaluation, truth_curve):
    positive = weights > 0
    expected_log_parameters = weights @ np.log(parameters)
    return {
        "entropy_nats": float(-np.sum(weights[positive] * np.log(weights[positive]))),
        "log_parameter_error": float(np.linalg.norm(expected_log_parameters - np.log(truth_parameters))),
        "prediction_rmse": float(np.sqrt(np.mean((weights @ evaluation - truth_curve) ** 2))),
    }


def summarise(trials):
    columns = [c for c in ["entropy_nats", "true_hypothesis_mass", "log_parameter_error", "prediction_rmse"] if c in trials]
    table = trials.groupby(["policy", "budget"], sort=True)[columns].agg(["mean", "std"])
    table.columns = [f"{metric}_{stat}" for metric, stat in table.columns]
    return table.reset_index()


def write_csv(table, path):
    table.to_csv(path, index=False, float_format="%.14g", lineterminator="\n")


def run(out, data_dir=ROOT / "data", seeds=20, grid_size=7):
    if not isinstance(seeds, int) or not 2 <= seeds <= 100:
        raise ValueError("seeds must be an integer between 2 and 100")
    if not isinstance(grid_size, int) or not 3 <= grid_size <= 11 or grid_size % 2 == 0:
        raise ValueError("grid_size must be an odd integer from 3 to 11")
    out = Path(out)
    if out.resolve() == Path(data_dir).resolve():
        raise ValueError("Output directory must differ from source data directory")
    out.mkdir(parents=True, exist_ok=True)
    model = load_model(data_dir)
    candidate_times = np.arange(100., 3601., 100.)
    evaluation_times = np.arange(0., 4001., 50.)
    all_times = np.unique(np.r_[candidate_times, evaluation_times])
    candidate_indices = np.searchsorted(all_times, candidate_times)
    evaluation_indices = np.searchsorted(all_times, evaluation_times)
    parameters = np.array([(scale, ki) for scale in np.linspace(.7, 1.3, grid_size)
                           for ki in np.linspace(4.5, 13.5, grid_size)])
    hypotheses = pd.DataFrame(parameters, columns=["v1_scale", "ki"])
    hypotheses.insert(0, "hypothesis_id", np.arange(len(parameters)))
    candidate_rows, evaluation_rows = [], []
    candidate_predictions, evaluation_predictions = [], []
    for hid, (scale, ki) in enumerate(parameters):
        states = model.simulate(all_times, scale, ki)
        fractions = states[:, [4, 7]] / 300.
        candidate_predictions.append(fractions[candidate_indices].ravel())
        evaluation_predictions.append(fractions[evaluation_indices].ravel())
        for times, indices, rows in ((candidate_times, candidate_indices, candidate_rows),
                                      (evaluation_times, evaluation_indices, evaluation_rows)):
            for t, values in zip(times, fractions[indices]):
                rows.append({"hypothesis_id": hid, "time": t, READOUTS[0]: values[0], READOUTS[1]: values[1]})
    predictions = np.asarray(candidate_predictions)
    evaluation = np.asarray(evaluation_predictions)
    candidates = pd.DataFrame({"candidate_id": np.arange(len(candidate_times) * 2),
                               "time": np.repeat(candidate_times, 2), "readout": list(READOUTS) * len(candidate_times)})
    trial_rows, selection_rows, posterior_rows, observation_rows, truth_rows = [], [], [], [], []
    for seed in range(seeds):
        rng = np.random.default_rng(seed)
        truth_id = int(rng.integers(len(parameters)))
        observed_pool = predictions[truth_id] + rng.normal(0, SIGMA, predictions.shape[1])
        truth_rows.append({"seed": seed, "truth_id": truth_id})
        observation_rows.extend({"seed": seed, "candidate_id": c, "observed": value} for c, value in enumerate(observed_pool))
        for policy in POLICIES:
            selected, snapshots = run_policy(predictions, observed_pool, policy, SIGMA, 10000 + seed)
            for step, candidate in enumerate(selected, 1):
                selection_rows.append({"seed": seed, "policy": policy, "step": step,
                                       "candidate_id": candidate, "observed": observed_pool[candidate]})
            for budget, weights in snapshots.items():
                trial_rows.append({"seed": seed, "policy": policy, "budget": budget,
                                   **metrics(weights, truth_id, parameters, evaluation)})
                posterior_rows.append({"seed": seed, "policy": policy, "budget": budget,
                                       **{f"h{h}": weight for h, weight in enumerate(weights)}})
    trials = pd.DataFrame(trial_rows)
    summary = summarise(trials)
    checks, baseline = numerical_checks(model, evaluation_times)
    tables = {
        "hypotheses.csv": hypotheses, "candidates.csv": candidates,
        "candidate_predictions.csv": pd.DataFrame(candidate_rows), "evaluation_predictions.csv": pd.DataFrame(evaluation_rows),
        "virtual_truths.csv": pd.DataFrame(truth_rows), "virtual_observations.csv": pd.DataFrame(observation_rows),
        "selection_log.csv": pd.DataFrame(selection_rows), "posterior_weights.csv": pd.DataFrame(posterior_rows),
        "trials.csv": trials, "summary.csv": summary,
        "baseline_trajectory.csv": pd.DataFrame({"time": evaluation_times, **dict(zip(SPECIES, baseline.T))}),
    }
    # One declared mismatch scenario, with a generating point absent from the grid.
    stress_parameters = np.array([1.05, 9.75])
    stress_states = model.simulate(all_times, *stress_parameters)
    stress_candidate = (stress_states[candidate_indices][:, [4, 7]] / 300.).ravel()
    stress_evaluation = (stress_states[evaluation_indices][:, [4, 7]] / 300.).ravel()
    stress_trials, stress_observations, stress_selections, stress_posteriors = [], [], [], []
    for seed in range(6):
        observed = stress_candidate + np.random.default_rng(20000 + seed).normal(0, SIGMA, len(stress_candidate))
        stress_observations.extend({"seed": seed, "candidate_id": c, "observed": value} for c, value in enumerate(observed))
        for policy in POLICIES:
            chosen, snapshots = run_policy(predictions, observed, policy, SIGMA, 30000 + seed)
            stress_selections.extend({"seed": seed, "policy": policy, "step": step, "candidate_id": c,
                                      "observed": observed[c]} for step, c in enumerate(chosen, 1))
            for budget, weights in snapshots.items():
                stress_trials.append({"seed": seed, "policy": policy, "budget": budget,
                                      **truth_metrics(weights, stress_parameters, parameters, evaluation, stress_evaluation)})
                stress_posteriors.append({"seed": seed, "policy": policy, "budget": budget,
                                          **{f"h{h}": weight for h, weight in enumerate(weights)}})
    stress_trials = pd.DataFrame(stress_trials)
    tables.update({"stress_trials.csv": stress_trials, "stress_summary.csv": summarise(stress_trials),
                   "stress_observations.csv": pd.DataFrame(stress_observations),
                   "stress_selection_log.csv": pd.DataFrame(stress_selections),
                   "stress_posterior_weights.csv": pd.DataFrame(stress_posteriors),
                   "stress_truth_predictions.csv": pd.DataFrame({"time": evaluation_times,
                       READOUTS[0]: stress_states[evaluation_indices, 4] / 300.,
                       READOUTS[1]: stress_states[evaluation_indices, 7] / 300.})})
    for name, table in tables.items():
        write_csv(table, out / name)
    (out / "solver_checks.json").write_text(json.dumps(checks, indent=2) + "\n")
    plot_results(out, trials, summary, evaluation_times, baseline)
    report(out, summary, checks, seeds, len(parameters), summarise(stress_trials))
    metadata = {
        "schema_version": 1, "package_version": __version__, "source": model.manifest,
        "dependencies": {"python": platform.python_version(), "numpy": np.__version__, "scipy": scipy.__version__,
                         "pandas": pd.__version__, "matplotlib": matplotlib.__version__},
        "configuration": {"seeds": list(range(seeds)), "grid_size": grid_size, "sigma": SIGMA,
                          "budgets": BUDGETS, "policies": POLICIES, "common_initial_candidates": [0, 1],
                          "truth_rule": "uniform integer on hypothesis IDs using default_rng(seed)",
                          "noise_rule": "same RNG after truth draw, iid normal by fixed candidate ID",
                          "random_policy_seed_rule": "10000 + seed", "solver": "BDF", "rtol": 1e-8, "atol": 1e-10,
                          "likelihood": "independent Gaussian with known fixed sigma", "prior": "uniform finite grid",
                          "acquisition": "maximum weighted variance of latent candidate mean; not exact information gain"},
        "stress_configuration": {"scenario": "off_grid_truth", "v1_scale": 1.05, "ki": 9.75,
                                 "seeds": list(range(6)), "sigma": SIGMA,
                                 "noise_seed_rule": "20000 + seed", "random_policy_seed_rule": "30000 + seed"},
        "code_sha256": {str(p.relative_to(ROOT)): hashlib.sha256(p.read_bytes()).hexdigest()
                        for p in sorted([*(ROOT / "mapk_lab").glob("*.py"), *(ROOT / "scripts").glob("*.py")])},
        "artifacts_sha256": {name: hashlib.sha256((out / name).read_bytes()).hexdigest()
                             for name in sorted([*tables, "solver_checks.json", "report.md", "dynamics_and_design.png", "paired_final_rmse.png"])},
        "scope": "Synthetic matched-model hypotheses only; no real measurements or biological validation.",
    }
    (out / "run_manifest.json").write_text(json.dumps(metadata, indent=2) + "\n")
    return metadata


def plot_results(out, trials, summary, times, baseline):
    fig, axes = plt.subplots(1, 2, figsize=(10, 3.8), constrained_layout=True)
    for col, label in ((4, "MKK-PP"), (7, "MAPK-PP")):
        axes[0].plot(times, baseline[:, col] / 300., label=label)
    axes[0].set(xlabel="Source model time", ylabel="Fraction of layer total", title="Pinned-model baseline")
    axes[0].legend()
    for policy, frame in summary.groupby("policy"):
        axes[1].errorbar(frame.budget, frame.prediction_rmse_mean,
                         yerr=frame.prediction_rmse_std / np.sqrt(trials.seed.nunique()), marker="o", capsize=3,
                         label=policy.replace("_", " "))
    axes[1].set(xlabel="Number of virtual observations", ylabel="Noiseless-curve RMSE", title="Mean ± descriptive SE across seeds")
    axes[1].legend(fontsize=8)
    fig.savefig(out / "dynamics_and_design.png", dpi=150, metadata={"Software": "mapk-dynamics-lab"})
    plt.close(fig)
    pivot = trials[trials.budget == max(BUDGETS)].pivot(index="seed", columns="policy", values="prediction_rmse")
    fig, ax = plt.subplots(figsize=(6, 3.8), constrained_layout=True)
    for baseline_policy, color in (("random", "#2a9d8f"), ("fixed", "#e9c46a")):
        ax.scatter(pivot[baseline_policy], pivot.variance_guided, label=f"vs {baseline_policy}", color=color)
    limit = max(float(pivot.max().max()) * 1.1, .005)
    ax.plot([0, limit], [0, limit], color="grey", linestyle="--")
    ax.set(xlabel="Baseline final RMSE", ylabel="Variance-guided final RMSE", title="Paired synthetic seeds; lower is better")
    ax.legend()
    fig.savefig(out / "paired_final_rmse.png", dpi=150, metadata={"Software": "mapk-dynamics-lab"})
    plt.close(fig)


def report(out, summary, checks, seeds, hypotheses, stress_summary):
    final = summary[summary.budget == max(BUDGETS)]
    lines = ["# Virtual MAPK measurement benchmark", "", f"{seeds} synthetic seeds, {hypotheses} hypotheses, 72 candidate observations and a budget of 12.",
             "The generating model belongs to the inference grid. These are simulated comparisons, not measurements from cells.", "",
             "| Policy | Mean final curve RMSE | Mean final entropy (nats) |", "|---|---:|---:|"]
    for row in final.itertuples():
        lines.append(f"| {row.policy} | {row.prediction_rmse_mean:.6f} | {row.entropy_nats_mean:.6f} |")
    lines += ["", "RMSE compares the posterior mean curve with the hidden noiseless curve at 81 times, including the unqueried 3650–4000 interval.",
              "Error bars in the figure are descriptive standard errors across matched seeds; no population or significance claim is made.", "",
              f"Baseline numerical checks passed: maximum default-BDF / tight-Radau difference {checks['bdf_vs_radau_max_abs']:.3g} source concentration units (threshold 0.002).",
              "The check concerns numerical agreement; it does not establish biological validity.", "",
              "Posterior mass, entropy and parameter error apply only to the declared two-parameter grid, known noise and fixed remaining parameters.",
              "Variance-guided acquisition is a heuristic. It cannot inspect hidden truth, future pool outcomes or evaluation curves."]
    lines += ["", "## Off-grid stress check", "",
              "Six further noise repeats use V1 scale 1.05 and Ki 9.75, absent from the unchanged hypothesis grid.",
              "This is a small numerical stress case, not a model-mismatch survey. The posterior has no 'none of the above' hypothesis.", "",
              "| Policy | Mean final curve RMSE | Mean final entropy (nats) |", "|---|---:|---:|"]
    for row in stress_summary[stress_summary.budget == max(BUDGETS)].itertuples():
        lines.append(f"| {row.policy} | {row.prediction_rmse_mean:.6f} | {row.entropy_nats_mean:.6f} |")
    lines += ["", "A concentrated grid posterior can coexist with prediction error when its generating point is missing.",
              "No true-hypothesis probability is reported for this scenario because the true point is outside the grid."]
    (out / "report.md").write_text("\n".join(lines) + "\n")
