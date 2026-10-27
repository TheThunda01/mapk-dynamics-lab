# MAPK dynamics lab

Which simulated observations help distinguish hypotheses about a signaling pathway?

This repository simulates a hidden parameter setting, selects a measurement,
updates the hypotheses, and repeats. It compares a variance-guided selection rule
with random and fixed schedules using a small, published MAPK model.

MAPK means mitogen-activated protein kinase, one layer of a signaling cascade.
A kinase adds a phosphate group to a target; this model links three kinase layers.

Start with the [project context](docs/project-context.md) for the motivation or
[biology and concepts](docs/biology-and-concepts.md) for a fuller explanation.

## Why this project

A time course can look plausible while leaving several parameter explanations
open. Another observation may help distinguish them.
The [Kholodenko (2000) model](https://pubmed.ncbi.nlm.nih.gov/10712587/) is small enough
to inspect and can show how feedback changes dynamics. Its size also lets readers
check the numerical implementation and compare repeated virtual experiments on
an ordinary computer.

The goal is to evaluate a decision rule under stated assumptions. This project
does not collect laboratory data, reproduce an original-paper figure, or establish
that the model captures a particular cell's behavior.

Figure 1 separates the information used to choose observations from the information reserved for evaluation. This separation keeps hidden answers out of the selection policy.

![Virtual measurement-loop diagram separating hidden simulated truth, revealed observations, allowed model predictions, posterior updating, selection and evaluation](docs/figures/virtual-loop.svg)

**Figure 1. Data access in the virtual measurement loop.** This is a software schematic, not laboratory automation. It follows [the implemented experiment](mapk_lab/experiment.py); the [methods table](docs/methods.md#finite-hypotheses-and-virtual-observations) gives the corresponding inputs and limits. The [figure builder](tools/build_documentation_figures.py) writes only documentation assets.

## What it does

- Verifies an offline BioModels snapshot released under CC0, an upstream public-domain dedication, and translates its eight species and ten reaction rates.
- Checks conserved totals, nonnegative trajectories, source MathML rates, tighter solver tolerances, and a separately written five-state formulation.
- Provides an optional COPASI import and baseline cross-engine comparison, with a native model, aligned species tables and explicit numerical acceptance checks.
- Compares three policies across 20 matched-model seeds, with 49 parameter hypotheses, 72 available observations and a 12-observation budget.
- Adds six off-grid noise repeats to expose the limits of a finite hypothesis set.
- Exports observations, selections, full posterior weights (updated probabilities over the allowed hypotheses), prediction tables and metrics, then independently replays the likelihood and acquisition calculations.

## Quick start

Use Python 3.11 or later, from the repository root:

```bash
python -m venv .venv
source .venv/bin/activate
python -m pip install -r requirements.txt
python scripts/run_benchmark.py --out .reproduction
python scripts/verify_results.py --results-dir .reproduction
python scripts/compare_results.py results .reproduction
python -m unittest discover -s tests -v
```

The Markdown report is written as UTF-8, including on systems with a different default text encoding.

The benchmark needs no network after dependencies are installed. The default run
takes under a minute in the development environment; runtime varies by machine.
Use `--seeds 2 --grid-size 3` for a smaller exploration. Those flags change the
experiment, so that run should not match the committed reference tables.

## Example results

Variance-guided selection had the lowest mean noiseless-curve root mean squared
error (RMSE) at budget 12 across the 20 matched-model seeds (Table 1).
The committed [report](results/report.md) records these simulation runs.

**Table 1. Mean final curve error in the matched-model simulation.**

| Selection rule | Mean RMSE |
|---|---:|
| Variance guided | 0.002679 |
| Fixed schedule | 0.010577 |
| Random schedule | 0.012998 |

![Simulated baseline dynamics and policy comparison](results/dynamics_and_design.png)

**Figure 2. Simulated dynamics and the matched-model policy comparison.** Sources: [baseline trajectory](results/baseline_trajectory.csv) and [trial summaries](results/summary.csv). Error bars are descriptive standard errors across computational seeds, not independent biological replicates. The [full report](results/report.md) defines the evaluation scope.

Both outputs are fractions of their kinase-layer totals. All policies share the
same first two observations and, within a seed, the same candidate-indexed noise.
Budget zero is the uniform prior: equal weights before any observations. The RMSE covers 81 times, including queried
points and an unqueried late interval; it is not a purely held-out error estimate.
See the [paired-seed plot](results/paired_final_rmse.png) and [full trials](results/trials.csv).

The separate [COPASI comparison](docs/copasi-comparison.md) checks the same baseline model through another importer and integration engine. All 648 concentration comparisons passed the declared 0.002 nM absolute criterion; the maximum difference was about 0.00005 nM. This is numerical agreement, not additional biological evidence.

In the off-grid check, the variance-guided rule had mean final RMSE 0.010007 and
entropy 0.820690 nats. Entropy measures how dispersed the weights are; nats use
natural logarithms. The generating point lies between allowed points but inside
both parameter ranges, so this check tests finite-grid resolution, not
out-of-range extrapolation.

Concentrated weights cannot add an excluded generating point to the hypothesis grid.
These examples support a bounded simulation comparison, not a general claim
that this rule is best.

Figure 3 compares final prediction error with posterior entropy for the variance-guided policy. Entropy describes how concentrated the hypothesis weights are; prediction error describes how close their averaged prediction is to the hidden simulated curve.

![Scatter plot of final curve error against posterior entropy for twenty grid-matched experiments and six noise repeats at one off-grid point](docs/figures/entropy-and-error.svg)

**Figure 3. Concentrated weights and accurate predictions are different summaries.** Sources: budget-12 rows from [matched-model trials](results/trials.csv) and [off-grid trials](results/stress_trials.csv), with exact input hashes in the [figure manifest](docs/figures/figure-manifest.json). Each point is a computational run. The groups use different generating settings, so their contrast does not isolate a causal effect of grid mismatch. No fitted trend or significance test is shown.

## Practical use and limitations

Use this project to test virtual observation-selection logic and audit a small
ordinary differential equation (ODE) translation. ODEs describe how modeled
quantities change over time.

The selection rule scores posterior-weighted variance of the latent (noiseless)
predicted mean, **not exact expected information gain**. The analysis assumes
normally distributed (Gaussian) noise, constant totals and a uniform grid prior.
Only two parameters vary; the others remain fixed.

The compact model omits explicit kinase–substrate complexes.
[Blüthgen et al. (2006)](https://pubmed.ncbi.nlm.nih.gov/16478465/) showed that
sequestration (binding into complexes) can alter the ultrasensitivity (a steep response to input) and oscillations (repeated temporal changes) predicted by this
model class. A numerically stable simulation is not experimental validation.
Read the [worked use case and checks](docs/practical-use.md) before adapting it.

## Documentation

The [21 October 2026 maintenance and scientific review](docs/review-2026-10-21.md) records the latest checks and their limits. Earlier review records remain available below.

- [Project context](docs/project-context.md) — background, rationale and main themes
- [Biology and concepts](docs/biology-and-concepts.md) — the cascade, feedback and identifiability
- [Methods](docs/methods.md) — equations, design, metrics and numerical checks
- [Practical use](docs/practical-use.md) — inputs, outputs, failures and a worked example
- [Literature review](docs/literature-review.md), [search log](docs/search-log.json) and [references](docs/references.md)
- [Provenance and related tools](docs/provenance-and-tools.md) — exact source, license and reuse boundaries

Definitions and interpretation: [glossary](docs/glossary.md), [assumptions](docs/assumptions.md), [reference audit](docs/reference-audit.json) and [dated review](docs/review-2026-10-20.md).

## Development and reuse

`mapk_lab/model.py` implements the model-specific translation;
`mapk_lab/experiment.py` separates acquisition from hidden-truth evaluation.
The verifier independently computes posterior likelihoods and metrics from CSVs.
Continuous integration (CI) runs tests, reruns the full experiment and compares every CSV numerically.

Original code is [MIT licensed](LICENSE). The encoded model remains
[CC0 with upstream attribution](DATA_LICENSE.md). No third-party application
implementation was copied. Please include model and method citations when using
the scientific ideas, and disclose changes to the hypothesis grid, noise or budget.

Rebuild Figures 1 and 3 with `python tools/build_documentation_figures.py`. The builder reads committed CSV files and writes `docs/figures/`; it does not rerun the model or replace analysis outputs.
