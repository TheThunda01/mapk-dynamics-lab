# Practical use

## Where this fits

Use this repository to inspect a compact model translation, teach finite-grid
Bayesian updating (revising hypothesis weights using an assumed observation likelihood), or compare a new virtual observation-selection rule against
declared baselines. It is also a reproducible example of connecting biological
assumptions to an auditable numerical experiment. It is not a general SBML
engine, a parameter-fitting service for arbitrary data, or a laboratory protocol.

## Input and output contract

The required input is the unmodified, hash-verified source snapshot in `data/`.
There is no external measurement file. The default configuration uses a 7×7
grid, 20 seed-indexed simulated truths and known Gaussian noise standard deviation (SD) 0.04.
The command-line interface (CLI) accepts `--data-dir`, `--out`, `--seeds` (integer 2–100) and `--grid-size`
(odd integer 3–11). The grid always spans the same ranges. The six-repeat off-grid
stress case remains fixed. Outputs must not share the input data directory.

| Output | What a reader can inspect |
|---|---|
| `hypotheses.csv`, `candidates.csv` | Allowed parameter settings and observation IDs |
| `candidate_predictions.csv`, `evaluation_predictions.csv` | Simulated means for every grid hypothesis |
| `virtual_truths.csv`, `virtual_observations.csv` | Declared hidden settings and complete synthetic pools |
| `selection_log.csv`, `posterior_weights.csv` | Every revealed observation and each saved posterior |
| `trials.csv`, `summary.csv` | Per-seed metrics and policy averages/sample SDs |
| `stress_*.csv` | Parallel evidence for the off-grid scenario |
| `baseline_trajectory.csv`, `solver_checks.json` | Eight-state trajectory and independent numerical comparisons |
| `run_manifest.json` | Model source, parameters, seeds, dependency versions, code and artifact hashes |
| `report.md`, two PNG figures | Human-readable summaries |

`verify_results.py` accepts `--results-dir`, `--data-dir` and optional `--out`
for its JSON receipt. Hash failure, missing/duplicate/fractional identity keys,
nonfinite values or arithmetic disagreement produce a nonzero exit. The run
command exits with code 2 on a handled invalid-input/solver failure; verification
and comparison exit with code 1 on a handled mismatch. Do not treat a partially
written failed-run folder as complete.

## Worked use case

Suppose you want to know whether a disagreement rule beats one simple fixed
schedule under precisely the same virtual data. Reproduce the declared run:

```bash
python scripts/run_benchmark.py --out .reproduction
python scripts/verify_results.py --results-dir .reproduction --out .reproduction/verification.json
python scripts/compare_results.py results .reproduction
```

Read `summary.csv` at budget 12, then check the paired seed rows rather than
judging the average alone. Inspect `selection_log.csv` to see where the strategies
spent their budget. For a chosen seed/policy, the `h0` through `h48` columns in
`posterior_weights.csv` show whether remaining ambiguity is spread out or highly
concentrated. The saved truth is used for evaluation only; giving it to a new
selection policy would invalidate the comparison.

Next inspect `stress_summary.csv`. Its generating setting is between grid points, inside both parameter ranges,
although the noise model remains correctly specified. This is discretization
mismatch, not extrapolation outside the ranges. Lower posterior
entropy cannot be read as assurance that the correct biological explanation
has been found. This example is intentionally small; do not select a preferred
policy using one favorable seed.

## Checks before relying on a result

Confirm the model accession and snapshot hashes; review the stated grid, fixed
parameters and observation units; check solver agreement and conservation; and
run the independent verifier on the folder you actually generated. Compare
complete CSVs with the reference run using the pinned dependencies. The manifest
records code hashes for provenance, but a self-consistent manifest is not an
authenticated signature. The verifier does not establish who produced files.

Before extending the experiment, explain what a measurement means, why its
error model is plausible and what questions the permitted observations can
answer. The current RMSE includes observed and unobserved times. Use a separately
defined evaluation target if you need strictly held-out prediction assessment.

## Known limits

Only V1 scale and Ki vary; neither a complete continuous posterior nor full-model
identifiability is established. There are no real observations, assay costs,
heterogeneous cells, unknown noise estimates or omitted-pathway comparisons.
The off-grid truth is a single numerical stress case. The baseline schedule is
simple and not optimized. Different priors, grids, parameter ranges, readouts,
noise or allowed times may reverse rankings. Successful ODE integration and
correct posterior arithmetic do not validate the compact biological model.

## Next improvements

Useful bounded extensions are separate noise-misspecification tests, several
off-grid truths, strictly unqueried evaluation windows and additional declared
fixed schedules. A genuinely different mechanism, such as an explicit-complex
model, needs its own licensed source and validation. Continuous inference or
real-data fitting should follow a fresh identifiability and observation-model
assessment, not simply add more parameters to this grid.

For definitions, see the [glossary](glossary.md); for the rationale and limits of each material choice, see the [assumptions](assumptions.md).
