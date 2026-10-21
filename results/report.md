# Virtual MAPK measurement benchmark

20 synthetic seeds, 49 hypotheses, 72 candidate observations and a budget of 12.
The generating model belongs to the inference grid. These are simulated comparisons, not measurements from cells.

| Policy | Mean final curve RMSE | Mean final entropy (nats) |
|---|---:|---:|
| fixed | 0.010577 | 1.067007 |
| random | 0.012998 | 1.145268 |
| variance_guided | 0.002679 | 0.388464 |

RMSE compares the posterior mean curve with the hidden noiseless curve at 81 times, including the unqueried 3650–4000 interval.
Error bars in the figure are descriptive standard errors across matched seeds; no population or significance claim is made.

Baseline numerical checks passed: maximum default-BDF / tight-Radau difference 4.96e-05 source concentration units (threshold 0.002).
The check concerns numerical agreement; it does not establish biological validity.

Posterior mass, entropy and parameter error apply only to the declared two-parameter grid, known noise and fixed remaining parameters.
Variance-guided acquisition is a heuristic. It cannot inspect hidden truth, future pool outcomes or evaluation curves.

## Off-grid stress check

Six further noise repeats use V1 scale 1.05 and Ki 9.75, absent from the unchanged hypothesis grid.
This is a small numerical stress case, not a model-mismatch survey. The posterior has no 'none of the above' hypothesis.

| Policy | Mean final curve RMSE | Mean final entropy (nats) |
|---|---:|---:|
| fixed | 0.012516 | 1.528481 |
| random | 0.020693 | 1.609693 |
| variance_guided | 0.010007 | 0.820690 |

A concentrated grid posterior can coexist with prediction error when its generating point is missing.
No true-hypothesis probability is reported for this scenario because the true point is outside the grid.
