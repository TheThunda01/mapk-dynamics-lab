#!/usr/bin/env python3
"""Independently replay saved likelihoods and recompute benchmark metrics."""
import argparse
import hashlib
import json
from pathlib import Path
import sys

import numpy as np
import pandas as pd

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
from mapk_lab.model import verify_sources

READOUTS = ["MKK_PP_fraction", "MAPK_PP_fraction"]


def require(condition, message):
    if not condition:
        raise ValueError(message)


def close(actual, expected, message):
    actual, expected = np.asarray(actual), np.asarray(expected)
    require(np.isfinite(actual).all() and np.isfinite(expected).all(), message + " (nonfinite value)")
    require(np.allclose(actual, expected, rtol=1e-9, atol=1e-10), message)


def checked_csv(directory, filename, keys):
    frame = pd.read_csv(directory / filename)
    require(not frame.duplicated(keys).any(), f"Duplicate keys in {filename}")
    for column in frame.select_dtypes(include=np.number):
        require(np.isfinite(frame[column]).all(), f"Nonfinite values in {filename}")
        if column in set(keys) | {"seed", "candidate_id", "hypothesis_id", "truth_id", "step", "budget"}:
            require(np.equal(frame[column], np.floor(frame[column])).all(), f"Noninteger identity in {filename}/{column}")
    return frame


def verify(directory=ROOT / "results", data_dir=ROOT / "data"):
    directory = Path(directory)
    source = verify_sources(data_dir)
    metadata = json.loads((directory / "run_manifest.json").read_text())
    require(metadata["source"] == source, "Run/source manifests differ")
    hashes = metadata["artifacts_sha256"]
    required = {"hypotheses.csv", "candidates.csv", "candidate_predictions.csv", "evaluation_predictions.csv",
                "virtual_truths.csv", "virtual_observations.csv", "selection_log.csv", "posterior_weights.csv",
                "trials.csv", "summary.csv", "baseline_trajectory.csv", "solver_checks.json",
                "stress_trials.csv", "stress_summary.csv", "stress_observations.csv", "stress_selection_log.csv",
                "stress_posterior_weights.csv", "stress_truth_predictions.csv", "report.md",
                "dynamics_and_design.png", "paired_final_rmse.png"}
    require(set(hashes) == required, "Artifact manifest is incomplete or has unexpected entries")
    for name, digest in hashes.items():
        require(Path(name).name == name, "Unsafe artifact path")
        require(hashlib.sha256((directory / name).read_bytes()).hexdigest() == digest, f"Artifact hash mismatch: {name}")
    config = metadata["configuration"]
    require(metadata["stress_configuration"]["v1_scale"] == 1.05 and metadata["stress_configuration"]["ki"] == 9.75
            and metadata["stress_configuration"]["sigma"] == .04, "Unexpected stress configuration")
    require(config["budgets"] == [0, 2, 4, 6, 8, 12] and config["policies"] == ["variance_guided", "random", "fixed"], "Unsupported benchmark configuration")
    require(config["sigma"] == 0.04, "Unexpected noise scale")
    hypotheses = checked_csv(directory, "hypotheses.csv", ["hypothesis_id"]).sort_values("hypothesis_id")
    size = config["grid_size"]
    parameters = np.array([(s, k) for s in np.linspace(.7, 1.3, size) for k in np.linspace(4.5, 13.5, size)])
    close(hypotheses.hypothesis_id, np.arange(size * size), "Invalid hypothesis IDs")
    close(hypotheses[["v1_scale", "ki"]], parameters, "Unexpected parameter grid")
    candidates = checked_csv(directory, "candidates.csv", ["candidate_id"]).sort_values("candidate_id")
    close(candidates.candidate_id, np.arange(72), "Invalid candidate IDs")
    close(candidates.time, np.repeat(np.arange(100, 3601, 100), 2), "Unexpected candidate times")
    require(candidates.readout.tolist() == READOUTS * 36, "Unexpected candidate readouts")
    matrices = []
    for filename, times in (("candidate_predictions.csv", np.arange(100, 3601, 100)),
                            ("evaluation_predictions.csv", np.arange(0, 4001, 50))):
        frame = checked_csv(directory, filename, ["hypothesis_id", "time"]).sort_values(["hypothesis_id", "time"])
        require(len(frame) == size * size * len(times), f"Incomplete {filename}")
        close(frame.hypothesis_id, np.repeat(np.arange(size * size), len(times)), f"Invalid IDs in {filename}")
        close(frame.time, np.tile(times, size * size), f"Invalid times in {filename}")
        matrices.append(frame[READOUTS].to_numpy().reshape(size * size, -1))
    predictions, evaluation = matrices
    truths = checked_csv(directory, "virtual_truths.csv", ["seed"]).set_index("seed")
    require(set(truths.index) == set(config["seeds"]), "Incomplete truth seeds")
    counts = {}
    for stress in (False, True):
        prefix = "stress_" if stress else ""
        seeds = metadata["stress_configuration"]["seeds"] if stress else config["seeds"]
        observations = checked_csv(directory, "stress_observations.csv" if stress else "virtual_observations.csv", ["seed", "candidate_id"])
        selections = checked_csv(directory, prefix + "selection_log.csv", ["seed", "policy", "step"])
        posterior = checked_csv(directory, prefix + "posterior_weights.csv", ["seed", "policy", "budget"]).set_index(["seed", "policy", "budget"])
        trials = checked_csv(directory, prefix + "trials.csv", ["seed", "policy", "budget"]).set_index(["seed", "policy", "budget"])
        expected_keys = {(s, p, b) for s in seeds for p in config["policies"] for b in config["budgets"]}
        require(set(posterior.index) == expected_keys and set(trials.index) == expected_keys, "Incomplete posterior/trial keys")
        require(len(observations) == len(seeds) * 72 and len(selections) == len(seeds) * 3 * 12, "Incomplete observation or selection records")
        if stress:
            stress_frame = checked_csv(directory, "stress_truth_predictions.csv", ["time"]).sort_values("time")
            close(stress_frame.time, np.arange(0, 4001, 50), "Unexpected stress truth times")
            truth_curve = stress_frame[READOUTS].to_numpy().ravel()
            # Candidate times are a subset of the exported evaluation times.
            truth_candidate = stress_frame.set_index("time").loc[np.arange(100, 3601, 100), READOUTS].to_numpy().ravel()
            truth_parameters = np.array([1.05, 9.75])
            require(not np.any(np.all(np.isclose(parameters, truth_parameters), axis=1)), "Stress truth is not off-grid")
        for seed in seeds:
            pool_rows = observations[observations.seed == seed].sort_values("candidate_id")
            close(pool_rows.candidate_id, np.arange(72), "Incomplete candidate observations")
            pool = pool_rows.observed.to_numpy()
            rng = np.random.default_rng((20000 + seed) if stress else seed)
            if not stress:
                truth_id = int(rng.integers(len(parameters)))
                require(truths.loc[seed, "truth_id"] == truth_id, "Truth generation mismatch")
                truth_curve, truth_candidate, truth_parameters = evaluation[truth_id], predictions[truth_id], parameters[truth_id]
            close(pool, truth_candidate + rng.normal(0, .04, 72), "Paired observation generation mismatch")
            for policy in config["policies"]:
                chosen = selections[(selections.seed == seed) & (selections.policy == policy)].sort_values("step")
                close(chosen.step, np.arange(1, 13), "Incomplete selection steps")
                ids = chosen.candidate_id.to_numpy(dtype=int)
                require(len(set(ids)) == 12 and np.all((ids >= 0) & (ids < 72)), "Repeated/invalid selected candidates")
                close(chosen.observed, pool[ids], "Selection values differ from shared observation pool")
                random = np.random.default_rng((30000 if stress else 10000) + seed)
                for budget in range(13):
                    # Batch log likelihood is independent of the pipeline's sequential updater.
                    logp = -.5 * np.sum(((predictions[:, ids[:budget]] - pool[ids[:budget]]) / .04) ** 2, axis=1)
                    weights = np.exp(logp - logp.max()); weights /= weights.sum()
                    if budget in config["budgets"]:
                        key = (seed, policy, budget)
                        saved = posterior.loc[key, [f"h{i}" for i in range(len(parameters))]].to_numpy(dtype=float)
                        close(saved, weights, "Saved posterior differs from independent likelihood replay")
                        keep = weights > 0
                        expected = {
                            "entropy_nats": -np.sum(weights[keep] * np.log(weights[keep])),
                            "prediction_rmse": np.sqrt(np.mean((weights @ evaluation - truth_curve) ** 2)),
                            "log_parameter_error": np.linalg.norm(weights @ np.log(parameters) - np.log(truth_parameters)),
                        }
                        if not stress:
                            expected["true_hypothesis_mass"] = weights[truth_id]
                        for column, value in expected.items():
                            close(trials.loc[key, column], value, f"Metric mismatch: {column}")
                    if budget == 12:
                        break
                    available = np.setdiff1d(np.arange(72), ids[:budget])
                    if budget < 2:
                        expected_id = budget
                    elif policy == "fixed":
                        expected_id = np.rint(np.linspace(2, 71, 10)).astype(int)[budget - 2]
                    elif policy == "random":
                        expected_id = random.choice(available)
                    else:
                        mean = weights @ predictions[:, available]
                        expected_id = available[np.argmax(weights @ ((predictions[:, available] - mean) ** 2))]
                    require(ids[budget] == expected_id, "Acquisition replay mismatch")
        summary = checked_csv(directory, prefix + "summary.csv", ["policy", "budget"]).set_index(["policy", "budget"])
        require(set(summary.index) == {(p, b) for p in config["policies"] for b in config["budgets"]}, "Incomplete summary keys")
        for key, group in trials.reset_index().groupby(["policy", "budget"]):
            for column in trials.columns:
                close(summary.loc[key, column + "_mean"], group[column].mean(), "Summary mean mismatch")
                close(summary.loc[key, column + "_std"], group[column].std(ddof=1), "Summary SD mismatch")
        counts["stress_trials" if stress else "matched_trials"] = len(trials)
    return {"passed": True, **counts, "posterior_rows": sum(counts.values()), "scope":
            "Checks pinned source and artifact hashes, key coverage, generated noise, policy replay, posterior likelihoods and metric arithmetic. Does not independently re-simulate exported trajectories, authenticate the manifest, or validate biology."}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--results-dir", type=Path, default=ROOT / "results")
    parser.add_argument("--data-dir", type=Path, default=ROOT / "data")
    parser.add_argument("--out", type=Path)
    args = parser.parse_args()
    try:
        result = verify(args.results_dir, args.data_dir)
    except (ValueError, KeyError, IndexError, OSError) as exc:
        parser.exit(1, f"verification failed: {exc}\n")
    text = json.dumps(result, indent=2) + "\n"
    if args.out:
        args.out.write_text(text)
    print(text, end="")


if __name__ == "__main__":
    main()
