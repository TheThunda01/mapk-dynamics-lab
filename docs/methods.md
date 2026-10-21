# Methods

## Model and equations

The computational input is the exact [BioModels archive](provenance-and-tools.md)
of BIOMD0000000010. We verify the three upstream file hashes before parsing.
SBML is Systems Biology Markup Language, an XML format for biological models. The loader supports this model's Level 2 SBML structure only. It is not a general
SBML simulator. It rejects unsupported rules, events, compartments and species
structures rather than silently interpreting them.

The state order is `MKKK, MKKK_P, MKK, MKK_P, MKK_PP, MAPK, MAPK_P, MAPK_PP`.
Initial values are `90,10,280,10,10,280,10,10`; layer totals are 100, 300 and 300.
Let $`(a,a_p,b,b_p,b_{pp},c,c_p,c_{pp})`$ denote those eight concentrations.
The ten rates, with the archived numerical constants, are:

```math
\begin{aligned}
v_0&=\frac{2.5s\,a}{(1+(c_{pp}/K_i)^1)(10+a)}, &v_1&=\frac{0.25a_p}{8+a_p},\\
v_2&=\frac{0.025a_pb}{15+b}, &v_3&=\frac{0.025a_pb_p}{15+b_p},\\
v_4&=\frac{0.75b_{pp}}{15+b_{pp}}, &v_5&=\frac{0.75b_p}{15+b_p},\\
v_6&=\frac{0.025b_{pp}c}{15+c}, &v_7&=\frac{0.025b_{pp}c_p}{15+c_p},\\
v_8&=\frac{0.5c_{pp}}{15+c_{pp}}, &v_9&=\frac{0.5c_p}{15+c_p}.
\end{aligned}
```

$`s`$ is a multiplier on the source parameter `V1`; the archived baseline has
$`s=1`$ and $`K_i=9`$. The compartment volume is fixed at one. The full derivative is
the source stoichiometry matrix times these rates. For the independent reduced
form, $`a=100-a_p`$, $`b=300-b_p-b_{pp}`$, $`c=300-c_p-c_{pp}`$, and:

```math
\begin{aligned}
\dot a_p&=v_0-v_1,\\
\dot b_p&=v_2-v_3-v_5+v_4,\\
\dot b_{pp}&=v_3-v_4,\\
\dot c_p&=v_6-v_7+v_8-v_9,\\
\dot c_{pp}&=v_7-v_8.
\end{aligned}
```

The XML names substance units as nanomoles and uses a unit-sized compartment;
many rate-parameter units are not separately annotated. We label axes with
source-model units and do not claim that these numbers define a transferable
experimental protocol.

## Numerical checks

The primary eight-state solver uses SciPy’s backward differentiation formulas (BDF), `rtol=1e-8`, `atol=1e-10`.
At the archived baseline, we compare it with tighter BDF and Radau solves
(`1e-10`, `1e-12`) and a five-state Radau solve (a different implicit integration method) whose rates are evaluated
directly from restricted source MathML, an XML representation of equations. Maximum disagreement must be at most
0.002 source concentration units. This is a declared engineering tolerance,
not a biological accuracy estimate. Every hypothesis solve must remain finite,
conserve each layer within `1e-5`, and remain at least `-1e-5`; negative values
are not clipped. Tests compare source MathML and explicit rates at twelve
strictly positive random states and three parameter pairs, in addition to
checking the reduced derivative signs.

The [saved checks](../results/solver_checks.json) apply to the baseline through
time 4000. They do not establish solver agreement for every conceivable
parameter, timespan or model revision.

## Finite hypotheses and virtual observations

Figure 1 is a map of the implemented data access. Table 1 describes the same boundary in text, including what the policy does not receive.

![Data-access diagram for the simulated MAPK loop, with hidden truth routed only to the simulator and evaluator](figures/virtual-loop.svg)

**Figure 1. The policy selects a query, not its answer.** Source: [experiment.py](../mapk_lab/experiment.py), especially `choose_candidate`, `run_policy` and `truth_metrics`. Solid arrows show the learning loop; dashed arrows show evaluation-only access. This is a software abstraction rather than a physical laboratory layout.

**Table 1. Information available at each stage.**

| Stage | Information it uses | Information or claim excluded |
| --- | --- | --- |
| Simulator | Hidden generating parameters and candidate-indexed noise | It does not use a policy's desired outcome. |
| Posterior update | Revealed values, allowed predictions and the stated likelihood | It does not add an unmodeled “none of the above” hypothesis. |
| Selection policy | Allowed predictions, current weights and selected candidate IDs | It does not receive the hidden curve or unrevealed outcomes. |
| Evaluator | Posterior predictions and the hidden noiseless curve | Its errors are diagnostic outputs, not inputs to the policy. |
| Comparison | Matched budgets and shared candidate noise within each seed | Computational seeds do not constitute independent biological replication. |

The default grid is the Cartesian product of seven V1 multipliers evenly
spaced from 0.7 to 1.3 and seven Ki values from 4.5 to 13.5. The other constants,
initial values and totals remain fixed. We assign a uniform prior to these 49
hypotheses. This discretization is neither a continuous parameter posterior
nor a proof of structural identifiability.

Each candidate is a single scalar: $`b_{pp}/300`$ or $`c_{pp}/300`$ (the `MKK_PP` or `MAPK_PP` readout), at one of
36 times, 100,200,...,3600. Each seed from 0 through 19 draws a uniform grid
truth with `default_rng(seed)`, then 72 independent Gaussian noise values with
known standard deviation 0.04. The resulting observation is stored by candidate
ID and reused across policies. Noise is additive and not clipped to [0,1],
so a virtual measurement can fall outside the noiseless fraction range.

A likelihood scores observations under each hypothesis. Here it is independent Gaussian with the same known noise scale.
Updates accumulate log likelihoods and normalize after subtracting their
maximum. Entropy measures the dispersion of the hypothesis weights; its unit is the nat when natural logarithms are used. Uniform-prior entropy at budget zero is $`\log(49)`$ nats.

## Sequential policies

All policies first query both readouts at time 100. Subsequent choices are:

- **Variance guided:** maximize the posterior-weighted variance of the latent
  predicted mean among unqueried candidates. Constant observation noise would
  add the same term to every score. This is a disagreement heuristic, not exact
  expected information gain or a globally optimal schedule. Ties use the first ID.
- **Random:** sample an unqueried candidate using `default_rng(10000+seed)`.
- **Fixed:** query IDs `[0,1]` followed by the ten rounded, evenly spaced indices
  from 2 through 71. This is a simple declared comparator, not an optimized one.

Selections never repeat. Budgets 0,2,4,6,8,12 record weights and metrics. The
acquisition function receives only the hypothesis predictions, current weights,
selected IDs and policy RNG. It cannot inspect the hidden truth, unqueried
observations or evaluation curves. The simulation driver reveals the requested
observation only after an ID is selected.

## Evaluation and stress case

We report posterior entropy; true-grid-point mass; Euclidean error of the
posterior mean log parameters; and RMSE of the posterior mean of the two output
curves versus the noiseless truth at 81 times from 0 to 4000 in steps of 50.
That curve error includes queried points and an unqueried late interval; it is
not an independent held-out estimate. Averages and sample standard deviations
summarize the 20 matched seeds; the plot uses SD divided by the square root of
20 as a descriptive standard error. We run no significance test.

An additional fixed truth, V1 scale 1.05 and Ki 9.75, lies between grid points,
inside both parameter ranges. It is absent from the finite hypothesis set; it
does not test extrapolation beyond the parameter ranges.
Six repeats use noise RNG seeds 20000–20005 and random-policy seeds 30000–30005,
with all other choices unchanged. This separates discretization mismatch from
noise-scale mismatch. We omit true-point mass because that point is absent.
One off-grid scenario is not a comprehensive robustness study.

## Independent output verification

`scripts/verify_results.py` checks source/artifact hashes and complete unique
keys, regenerates the declared synthetic noise, replays policy choices, computes
batch likelihoods from the selected observations, and independently recomputes
posteriors, metrics, means and sample SDs. The implementation does not call the
pipeline's likelihood, policy or metric helpers. It checks both scenarios.
Its `1e-9` relative and `1e-10` absolute comparison tolerances allow CSV rounding.

This checks the exported arithmetic and consistency. It does not re-simulate
every exported trajectory, authenticate a manifest supplied by an untrusted
party, or establish biological validity. The solver/source tests and full
fresh-run CSV comparison address different parts of reproducibility.

For definitions, see the [glossary](glossary.md); for the rationale and limits of each material choice, see the [assumptions](assumptions.md).
