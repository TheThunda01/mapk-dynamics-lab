"""Model-specific translation of the pinned BioModels SBML, not a general engine."""
from dataclasses import dataclass
import hashlib
import json
from pathlib import Path
import xml.etree.ElementTree as ET

import numpy as np
from scipy.integrate import solve_ivp

SBML = "{http://www.sbml.org/sbml/level2/version4}"
MATH = "{http://www.w3.org/1998/Math/MathML}"
SPECIES = ("MKKK", "MKKK_P", "MKK", "MKK_P", "MKK_PP", "MAPK", "MAPK_P", "MAPK_PP")
REACTIONS = tuple(f"J{i}" for i in range(10))
TOTALS = np.array([100., 300., 300.])
GROUPS = ((0, 1), (2, 3, 4), (5, 6, 7))
ROOT = Path(__file__).resolve().parents[1]


def verify_sources(data_dir=ROOT / "data"):
    directory = Path(data_dir)
    manifest = json.loads((directory / "manifest.json").read_text())
    if manifest.get("accession") != "BIOMD0000000010":
        raise ValueError("Unsupported model accession")
    paths = set()
    for entry in manifest["files"]:
        name = entry["path"]
        if Path(name).name != name or name in paths:
            raise ValueError("Source manifest requires unique plain filenames")
        paths.add(name)
        raw = (directory / name).read_bytes()
        if len(raw) != entry["bytes"] or hashlib.sha256(raw).hexdigest() != entry["sha256"]:
            raise ValueError(f"Source integrity check failed: {name}")
    if "model.xml" not in paths:
        raise ValueError("Source manifest must include model.xml")
    return manifest


def evaluate_math(node, environment):
    """Evaluate only the arithmetic operators used by this archived model."""
    tag = node.tag.removeprefix(MATH)
    if tag == "math":
        if len(node) != 1:
            raise ValueError("Expected one MathML expression")
        return evaluate_math(node[0], environment)
    if tag == "ci":
        return environment[(node.text or "").strip()]
    if tag == "cn":
        return float(node.text)
    if tag != "apply" or len(node) < 2:
        raise ValueError(f"Unsupported MathML element: {tag}")
    op = node[0].tag.removeprefix(MATH)
    args = [evaluate_math(child, environment) for child in node[1:]]
    if op == "plus":
        return sum(args)
    if op == "times":
        return float(np.prod(args))
    if op == "divide" and len(args) == 2:
        return args[0] / args[1]
    if op == "power" and len(args) == 2:
        return args[0] ** args[1]
    raise ValueError(f"Unsupported MathML operator: {op}")


@dataclass
class Model:
    initial: np.ndarray
    stoichiometry: np.ndarray
    parameters: list
    expressions: list
    manifest: dict

    def fluxes(self, y, v1_scale=1., ki=9.):
        if not np.isfinite(v1_scale) or v1_scale <= 0 or not np.isfinite(ki) or ki <= 0:
            raise ValueError("v1_scale and ki must be finite and positive")
        a, ap, b, bp, bpp, c, cp, cpp = y
        p = self.parameters
        return np.array([
            p[0]["V1"] * v1_scale * a / ((1 + (cpp / ki) ** p[0]["n"]) * (p[0]["K1"] + a)),
            p[1]["V2"] * ap / (p[1]["KK2"] + ap),
            p[2]["k3"] * ap * b / (p[2]["KK3"] + b),
            p[3]["k4"] * ap * bp / (p[3]["KK4"] + bp),
            p[4]["V5"] * bpp / (p[4]["KK5"] + bpp),
            p[5]["V6"] * bp / (p[5]["KK6"] + bp),
            p[6]["k7"] * bpp * c / (p[6]["KK7"] + c),
            p[7]["k8"] * bpp * cp / (p[7]["KK8"] + cp),
            p[8]["V9"] * cpp / (p[8]["KK9"] + cpp),
            p[9]["V10"] * cp / (p[9]["KK10"] + cp),
        ])

    def source_fluxes(self, y, v1_scale=1., ki=9.):
        base = dict(zip(SPECIES, y)) | {"uVol": 1.}
        result = []
        for i, (parameters, expression) in enumerate(zip(self.parameters, self.expressions)):
            env = base | parameters
            if i == 0:
                env.update(V1=parameters["V1"] * v1_scale, Ki=ki)
            result.append(evaluate_math(expression, env))
        return np.asarray(result)

    def rhs(self, t, y, v1_scale=1., ki=9.):
        return self.stoichiometry @ self.fluxes(y, v1_scale, ki)

    def reduced_rhs(self, t, x, v1_scale=1., ki=9.):
        """Conservation-reduced equations, separately written signs."""
        ap, bp, bpp, cp, cpp = x
        y = [100 - ap, ap, 300 - bp - bpp, bp, bpp, 300 - cp - cpp, cp, cpp]
        v = self.source_fluxes(y, v1_scale, ki)
        return np.array([v[0] - v[1], v[2] - v[3] - v[5] + v[4],
                         v[3] - v[4], v[6] - v[7] + v[8] - v[9], v[7] - v[8]])

    def simulate(self, times, v1_scale=1., ki=9., method="BDF", rtol=1e-8, atol=1e-10):
        times = np.asarray(times, dtype=float)
        if times.ndim != 1 or len(times) < 2 or not np.isfinite(times).all() or times[0] < 0 or np.any(np.diff(times) <= 0):
            raise ValueError("times must be finite, nonnegative, strictly increasing, and length >= 2")
        self.fluxes(self.initial, v1_scale, ki)  # validate before solver wraps the call
        sol = solve_ivp(self.rhs, (0, times[-1]), self.initial, args=(v1_scale, ki),
                        t_eval=times, method=method, rtol=rtol, atol=atol)
        if not sol.success or sol.y.shape != (8, len(times)) or not np.isfinite(sol.y).all():
            raise ValueError(f"ODE integration failed: {sol.message}")
        y = sol.y.T
        deviation = max(float(np.max(np.abs(y[:, group].sum(axis=1) - total)))
                        for group, total in zip(GROUPS, TOTALS))
        if y.min() < -1e-5 or deviation > 1e-5:
            raise ValueError("Integration violates nonnegativity or conserved totals")
        return y


def load_model(data_dir=ROOT / "data"):
    manifest = verify_sources(data_dir)
    raw = (Path(data_dir) / "model.xml").read_bytes()
    if b"<!DOCTYPE" in raw.upper() or b"<!ENTITY" in raw.upper():
        raise ValueError("DTD and entity declarations are unsupported")
    doc = ET.fromstring(raw)
    model = doc.find(SBML + "model")
    if doc.attrib.get("level") != "2" or model is None or model.attrib.get("id") != manifest["accession"]:
        raise ValueError("Unexpected SBML model")
    if any(model.find(SBML + name) is not None for name in ("listOfRules", "listOfEvents", "listOfParameters")):
        raise ValueError("This translation does not support rules, events, or global parameters")
    compartments = model.findall(f"{SBML}listOfCompartments/{SBML}compartment")
    if len(compartments) != 1 or compartments[0].get("id") != "uVol" or float(compartments[0].get("size")) != 1:
        raise ValueError("Expected fixed unit-volume compartment")
    species = model.findall(f"{SBML}listOfSpecies/{SBML}species")
    if tuple(s.get("id") for s in species) != SPECIES:
        raise ValueError("Unexpected species ordering")
    initial = np.array([float(s.get("initialConcentration")) for s in species])
    if not np.isfinite(initial).all() or np.any(initial < 0):
        raise ValueError("Invalid initial concentrations")
    if not np.allclose([initial[list(g)].sum() for g in GROUPS], TOTALS):
        raise ValueError("Unexpected conserved totals")
    reactions = model.findall(f"{SBML}listOfReactions/{SBML}reaction")
    if tuple(r.get("id") for r in reactions) != REACTIONS:
        raise ValueError("Unexpected reactions")
    matrix = np.zeros((8, 10))
    parameters, expressions = [], []
    for j, reaction in enumerate(reactions):
        for label, sign in (("listOfReactants", -1), ("listOfProducts", 1)):
            for ref in reaction.findall(f"{SBML}{label}/{SBML}speciesReference"):
                matrix[SPECIES.index(ref.get("species")), j] += sign * float(ref.get("stoichiometry", "1"))
        params = reaction.findall(f"{SBML}kineticLaw/{SBML}listOfParameters/{SBML}parameter")
        parameters.append({p.get("id"): float(p.get("value")) for p in params})
        expressions.append(reaction.find(f"{SBML}kineticLaw/{MATH}math"))
    if sum(map(len, parameters)) != 22 or any(e is None for e in expressions):
        raise ValueError("Unexpected kinetic law structure")
    for group in GROUPS:
        if not np.array_equal(matrix[list(group)].sum(axis=0), np.zeros(10)):
            raise ValueError("Stoichiometry does not conserve each layer")
    result = Model(initial, matrix, parameters, expressions, manifest)
    if not np.allclose(result.fluxes(initial), result.source_fluxes(initial), rtol=1e-13, atol=1e-13):
        raise ValueError("Source MathML and translated rates disagree")
    return result


def numerical_checks(model, times):
    normal = model.simulate(times)
    tight = model.simulate(times, rtol=1e-10, atol=1e-12)
    alternate = model.simulate(times, method="Radau", rtol=1e-10, atol=1e-12)
    reduced = solve_ivp(model.reduced_rhs, (0, float(times[-1])), model.initial[[1, 3, 4, 6, 7]],
                        t_eval=times, method="Radau", rtol=1e-10, atol=1e-12)
    if not reduced.success:
        raise ValueError("Independent reduced solve failed")
    errors = {
        "bdf_vs_tighter_bdf_max_abs": float(np.max(np.abs(normal - tight))),
        "bdf_vs_radau_max_abs": float(np.max(np.abs(normal - alternate))),
        "full_vs_reduced_radau_max_abs": float(np.max(np.abs(alternate[:, [1, 3, 4, 6, 7]] - reduced.y.T))),
        "conservation_max_abs": max(float(np.max(np.abs(normal[:, group].sum(axis=1) - total))) for group, total in zip(GROUPS, TOTALS)),
        "minimum_concentration": float(normal.min()),
    }
    errors["tolerance_max_abs"] = 0.002
    errors["passed"] = all(errors[k] <= errors["tolerance_max_abs"] for k in
                            ("bdf_vs_tighter_bdf_max_abs", "bdf_vs_radau_max_abs", "full_vs_reduced_radau_max_abs"))
    if not errors["passed"]:
        raise ValueError(f"Solver agreement check failed: {errors}")
    return errors, normal
