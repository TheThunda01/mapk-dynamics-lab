# Why build a virtual signaling experiment?

With a limited observation budget, timing matters. Regular sampling is simple,
but it may repeatedly measure moments when competing explanations predict nearly
the same outcome. The question extends beyond “which parameters fit?” to “which
observation could distinguish the explanations that remain plausible?”

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
The experiment saves all observations, selected IDs and posterior weights so
readers can audit the comparison beyond its summary plots.

The project connects biological assumptions to equations, numerical solutions,
uncertainty and sequential decisions. An independent verifier checks the exported
arithmetic; a second solver and a conservation-reduced implementation check the
dynamics numerically. A small off-grid scenario exposes a separate limitation:
a concentrated posterior does not guarantee that the allowed hypotheses include
the generating explanation.

The central themes are mechanistic modeling, reproducibility, conditional
uncertainty and virtual experimental design. The study by
[Liu et al. (2025)](https://pubmed.ncbi.nlm.nih.gov/41321992/)
supports investigating observation choice, but this repository uses its own
simple variance heuristic. It does not reproduce that paper's algorithm.

The simulation does not establish the behavior of real cells. The compact model
omits complexes whose sequestration can change cascade dynamics, as demonstrated by
[Blüthgen et al. (2006)](https://pubmed.ncbi.nlm.nih.gov/16478465/). The appropriate
next step is a broader computational stress test or a carefully specified
comparison with suitable measurements. Either step requires reassessing the
model and observation assumptions. The current result remains a simulation benchmark.

For definitions, see the [glossary](glossary.md); for the rationale and limits of each material choice, see the [assumptions](assumptions.md).
