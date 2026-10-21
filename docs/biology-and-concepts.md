# Biology and concepts

## A signaling cascade, not a direct readout of cell behavior

Cells respond to signals through networks of interacting molecules. One common arrangement is a cascade: an active kinase promotes phosphorylation of another kinase, which acts on the next layer. Phosphatases oppose these changes. MAPK cascades are useful examples because their responses can depend on both the amount of stimulation and the timing of activation.

This project uses the compact model published by [Kholodenko in 2000](https://pubmed.ncbi.nlm.nih.gov/10712587/) and encoded in the public BioModels entry BIOMD0000000010. Its three layers represent MAPKKK, MAPKK, and MAPK. These are model components, not a complete inventory of signaling in a particular cell. A simulated increase in phosphorylated MAPK does not, by itself, predict proliferation, survival, drug response, or any other cellular outcome.

## What the state variables mean

The archive tracks eight chemical species. MAPKKK has unphosphorylated and phosphorylated forms. Each downstream kinase has unphosphorylated, singly phosphorylated, and doubly phosphorylated forms. Ten reaction rates move material between these forms. The model includes no protein synthesis or degradation, so the total amount in each kinase layer stays constant.

Those conserved totals allow five independent state variables: knowing the phosphorylated forms determines the remaining unphosphorylated amount. Conservation is therefore more than a convenient check. It is part of the model's biological assumption. It would cease to describe a system in which total protein abundance changed substantially over the observation period.

The SBML file records initial concentrations, reaction formulas, parameter values, and a unit-sized compartment. Several parameter units are implicit rather than individually annotated. The implementation follows the declared model conventions; its numerical values should not be treated as a fully documented assay or transferred directly into a different biological setting.

## Why feedback can change the dynamics

In this model, doubly phosphorylated MAPK inhibits activation of the first kinase layer. That closes a negative feedback loop. A stronger downstream signal can reduce its own upstream input. The original study showed how negative feedback combined with a sufficiently sensitive cascade can produce sustained oscillations under particular assumptions and parameter choices. It did not establish that every MAPK pathway oscillates. [Kholodenko, 2000](https://pubmed.ncbi.nlm.nih.gov/10712587/)

There is also relevant contrary evidence about the model assumptions. [Blüthgen and colleagues](https://pubmed.ncbi.nlm.nih.gov/16478465/) examined sequestration, where enzymes and their targets spend time bound in complexes. Their modeling showed that this can reduce ultrasensitivity and remove oscillatory behavior in a feedback cascade. Our compact model does not explicitly represent those complexes. A clean simulated oscillation is consequently a result within this model, not proof of a mechanism operating in real cells.

## What the computer actually observes

All observations used by the learning experiment are simulated. A hidden parameter setting generates a trajectory, and a declared noise model supplies artificial measurement variation. A query reveals one selected simulated observation. No laboratory measurement is collected, and no historical time-course table is presented as if it had been measured for this project.

This separation lets us test an algorithm: did it recover the hidden simulation setting, and did it predict other simulated observations well? It cannot establish whether the same procedure would work with biological heterogeneity, unknown assay bias, missing reactions, or a different measurement scale. The chosen noisy observation model is an assumption to examine, not a property demonstrated by the source archive.

## Learning over a small set of hypotheses

The learning task varies two declared parameter directions related to upstream activation and feedback while holding the remaining model parameters fixed. Each point on the parameter grid is a hypothesis about the simulated system. Before observing data, prior weights describe which hypotheses are allowed and how much weight each receives. As observations arrive, their likelihoods update those weights.

The resulting posterior is conditional on that grid, the fixed parameters, and the chosen noise model. It is not a posterior over every possible signaling network or every continuous parameter value. A sharp concentration of weight can be misleading if the true setting lies outside the grid or if an omitted mechanism explains the observations better.

This is also different from proving structural identifiability. Structural identifiability asks whether ideal observations could uniquely determine parameters of a specified model. Practical identifiability additionally depends on finite, noisy data. Learning two grid coordinates while fixing the other constants does not answer either question for the full model. The distinction is discussed in [Liu and colleagues' study of sequential data collection](https://pubmed.ncbi.nlm.nih.gov/41321992/).

## What closes the loop

After an observation changes the hypothesis weights, the selection rule uses the updated predictions to choose another allowed observation. This dependence on earlier observations is the closed loop. Random and fixed selection rules provide comparisons under the same budget. High disagreement among hypotheses can suggest an informative query, but a disagreement score is not automatically an exact expected-information calculation or a globally optimal design.

The useful questions are modest and testable: does the declared rule improve recovery under the stated simulation assumptions, when does it fail, and do its conclusions change with noise or model mismatch? Recent work demonstrates that sequential selection can improve practical identifiability in synthetic examples, while remaining dependent on the model and observation assumptions. [Liu et al., 2025](https://pubmed.ncbi.nlm.nih.gov/41321992/)

## Reproducibility before interpretation

A solver approximates the differential equations. Tighter numerical tolerances, nonnegative concentrations, and conserved totals help check that approximation; they do not validate the underlying biology. The [SciPy solver documentation](https://docs.scipy.org/doc/scipy-1.17.0/reference/generated/scipy.integrate.solve_ivp.html) explains its error-control settings. Likewise, reproducing a pinned SBML simulation is distinct from reproducing an original article figure, which also needs its simulation settings and parameter choices. [Xu and Smith, 2024](https://pubmed.ncbi.nlm.nih.gov/39636894/)
