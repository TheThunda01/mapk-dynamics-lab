# Glossary: signaling, inference and virtual measurements

These definitions explain how terms are used in this project. A software check, a model assumption and biological evidence answer different questions. See the [assumption register](assumptions.md) for the conditions behind the calculations.

## Biology and model

| Term | Meaning here |
| --- | --- |
| Signal transduction; cascade | Signal transduction passes information through molecular interactions. A cascade links several stages, as in the three kinase layers modeled here. |
| Kinase; phosphorylation; phosphatase | A kinase catalyzes transfer of a phosphate group, here to another protein. Phosphorylation adds that group; a phosphatase removes it. |
| MAPK; MAPKK; MAPKKK | Mitogen-activated protein kinase; its activating kinase; and the kinase acting on that middle layer. The code abbreviates the latter two as MKK and MKKK. |
| P; PP; species; state | P and PP mark singly and doubly phosphorylated forms. A species is one modeled molecular form; the state lists their quantities at a time. |
| Negative feedback | A downstream component inhibits an upstream step. Here doubly phosphorylated MAPK reduces first-layer activation. |
| Ultrasensitivity; oscillation | Ultrasensitivity is a response steeper than a simple noncooperative hyperbola. An oscillation is repeated variation over time. Their appearance in a model does not establish behavior of a real cell. |
| Sequestration; enzyme–substrate complex | Binding can temporarily remove free enzyme or substrate into a complex. These complexes are not explicit species in this compact model. |
| Conserved total; compartment | A conserved total remains unchanged under the model equations. A compartment is the modeled volume containing species; this encoding uses a fixed unit-sized compartment. |
| Mechanistic model; parameter; V1 scale; Ki | A mechanistic model expresses proposed processes in equations. Parameters are fixed constants within a run. V1 scale multiplies upstream activation capacity; Ki sets the feedback scale in the encoded rate law and is not independently measured here. |
| Readout; fraction; observation model | A readout is a selected quantity to observe. The two readouts divide doubly phosphorylated species by a layer total of 300. The observation model adds the declared artificial noise. |
| Synthetic; virtual; latent | Synthetic and virtual denote generated, rather than laboratory-measured, data. Latent predictions are the underlying noiseless means in this experiment. |

## Inference and experimental choice

| Term | Meaning here |
| --- | --- |
| Hypothesis; grid; Cartesian product | A hypothesis is an allowed pair of parameters. The grid is the Cartesian product: every selected V1 scale paired with every selected Ki, giving 49 default possibilities. |
| Prior; likelihood; posterior; Bayesian update | The prior assigns weights before observations. The likelihood scores an observation under each hypothesis. The posterior combines them; an update revises the weights after a revealed observation. |
| Uniform prior; conditional uncertainty | Uniform gives equal initial weight to each grid point. All reported uncertainty is conditional on that grid, fixed model and noise assumptions; it does not cover every possible mechanism. |
| Gaussian noise; SD; variance; independence | Gaussian means normally distributed; SD is standard deviation, and variance is its square. Independent noise values do not inform one another in the assumed generator. |
| Entropy; nat | Entropy $`H=-\sum_i p_i\log p_i`$ describes spread of discrete weights. A nat is its unit when natural logarithms are used. Lower entropy need not mean more accurate biology. |
| Posterior mean; true-point mass | A posterior mean averages predictions or parameters using the weights. True-point mass is the weight at the generating grid hypothesis; it is undefined when that point is absent. |
| Policy; acquisition; candidate; budget | A policy chooses which permitted candidate observation to reveal. Acquisition is this selection step. The budget limits how many scalar observations may be revealed. |
| Active learning; closed loop | The next observation depends on what has already been learned. Here this occurs only in simulation; no laboratory equipment is controlled. |
| Variance-guided heuristic; expected information gain | The heuristic selects high weighted disagreement in noiseless predictions. Expected information gain would average a defined posterior-uncertainty reduction over possible future observations; that calculation is not implemented. |
| Structural versus practical identifiability | Structural identifiability concerns parameter uniqueness with ideal observations. Practical identifiability concerns finite noisy data. Distinguishing 49 pairs while fixing other constants does not establish either for the full model. |
| Matched-model; off-grid; discretization mismatch | Matched-model truth is one allowed hypothesis. Off-grid truth here is between points but inside their ranges; the missing point creates discretization mismatch without changing the mechanism. |
| Extrapolation; held-out evaluation | Extrapolation predicts beyond a specified observed or parameter range. Held-out evaluation reserves observations from fitting/selection. The main curve RMSE includes queried times and is not wholly held out. |
| RMSE; log-parameter error | Root mean squared error measures prediction differences in fraction units. The log-parameter error is Euclidean distance between the weighted mean of log parameters and their true logs. |
| Seed; paired comparison; sample SD; standard error | A seed initializes a pseudorandom number generator (RNG). Policies share a simulated truth and noise pool within each seed. Sample SD describes variation across seeds; SD divided by the square root of their count is the reported descriptive standard error, not biological replication. |

## Numerical work and files

| Term | Meaning here |
| --- | --- |
| ODE; derivative; trajectory | An ordinary differential equation describes time derivatives of states. Numerical integration approximates its solution trajectory from initial values. |
| Stoichiometric matrix; reduced model | The matrix converts reaction rates into species derivatives. The five-state reduced implementation reconstructs three species from conserved totals. |
| BDF; Radau; stiffness | Backward differentiation formulas and Radau methods are numerical ODE integrators. Stiffness involves disparate timescales that can constrain explicit methods. Agreement is a numerical check, not a biological test. |
| rtol; atol; numerical tolerance | Relative and absolute tolerances govern local numerical error control. They are not guaranteed bounds on every final prediction error. |
| SBML; XML; MathML; OMEX | Systems Biology Markup Language encodes a model in XML structured text. MathML represents equations. An OMEX archive bundles computational modeling files; this project does not reproduce the cited OMEX workflow. |
| CLI; CSV; JSON; PNG; CI; API | Command-line interface; text tables; structured records; image files; automated integration checks; and a software programming interface. |
| Hash; SHA-256; manifest; pinned snapshot; provenance | A hash compares file bytes; SHA-256 is the algorithm. A manifest records files and settings. A pinned snapshot fixes a revision; provenance documents its origin and processing. |
| CC0; MIT; dependency | CC0 is the upstream model’s dedication; MIT licenses original code/documentation. Dependencies are installed libraries with their own terms. |
