# Why build a virtual signaling experiment?

Imagine having enough resources to observe a pathway only a few more times.
Sampling at regular intervals is simple, but it may repeatedly measure moments
where competing explanations make nearly identical predictions. The useful
question is not only “which parameters fit?” It is also “which observation could
help separate the explanations we still consider plausible?”

This project explores that question with a deliberately small mathematical
system. The [Kholodenko (2000) MAPK model](https://pubmed.ncbi.nlm.nih.gov/10712587/)
represents a three-layer phosphorylation cascade with downstream negative
feedback. It can generate changing, sometimes oscillatory, activity under its
assumptions. The archived model is compact enough that a reader can follow its
rates, conservation laws and parameter choices without a large modeling framework.

The experiment starts with 49 parameter hypotheses and a uniform prior. A
simulated hidden setting produces noisy observations of two active kinase
fractions. Three policies spend the same observation budget: a predetermined
schedule, random selection and a rule that seeks disagreement among the current
hypotheses. After each query, Gaussian likelihoods update the hypothesis weights.
The full observations, selected IDs and posterior weights are saved, so the
comparison can be audited rather than accepted from a plot alone.

There are two reasons this matters for a computational biology portfolio. First,
it connects biological assumptions to equations, solver behavior, uncertainty
and a concrete sequential decision. Second, it makes the limits of that decision
visible. An independent verifier checks the exported arithmetic. A second solver
and a conservation-reduced implementation check the dynamics numerically. A small
off-grid scenario shows why a concentrated posterior does not guarantee that the
right explanation was among the allowed hypotheses.

The central themes are mechanistic modeling, reproducibility, conditional
uncertainty and virtual experimental design. The study by
[Liu et al. (2025)](https://pubmed.ncbi.nlm.nih.gov/41321992/)
supports investigating observation choice, but this repository uses its own
simple variance heuristic. It does not reproduce that paper's algorithm.

Nothing here establishes the behavior of real cells. The compact model omits
complexes whose sequestration can change cascade dynamics, as demonstrated by
[Blüthgen et al. (2006)](https://pubmed.ncbi.nlm.nih.gov/16478465/). The appropriate
next step is a broader computational stress test or a carefully specified
comparison with suitable measurements, with the model and observation assumptions
reassessed first. The current result is a transparent simulation benchmark.

For definitions, see the [glossary](glossary.md); for the rationale and limits of each material choice, see the [assumptions](assumptions.md).
