# Provenance and related tools

## Exact computational source

The offline input is the official BioModels GitHub mirror of
[BIOMD0000000010](https://github.com/biomodels/BIOMD0000000010/tree/d95a205b39b7e5bdc172a368534cda60c74ab420),
commit `d95a205b39b7e5bdc172a368534cda60c74ab420`, retrieved 2026-10-20.
The XML is 28,541 bytes with SHA-256
`f36baf246fc4f4548f23682d02d99c48bd8d3e2ab211901938cbc724e94c53b6`.
The [manifest](../data/manifest.json) also records exact URLs, sizes and hashes
for the unmodified upstream README and CC0 license. Those files are retained
as bytes, including their original line endings. A changed hash stops the run.

The canonical BioModels web route could not be inspected during this task
because it returned an access error. Model structure, annotations and license
were inspected in the accessible official GitHub mirror. The SBML annotation
dates its last modification to 2014-05-30. We intentionally use that snapshot;
we do not claim it is the latest curation or that it reproduces the complete
original publication's figures. The [2024 curation study](https://pubmed.ncbi.nlm.nih.gov/39636894/)
is a reason to keep model encodings and simulation settings distinct.

## Ideas, code and other implementations

The BioModels repository supplies the encoded model and its metadata, which are
copied under CC0. This project's Python translation, restricted MathML evaluator,
finite-grid updater, policy implementation and CSV verifier are original code.
There is no copied third-party application implementation.

[SciPy](https://github.com/scipy/scipy) supplies the actual numerical solvers;
the tested version is 1.17.0. The project uses its documented BDF and Radau
interfaces, rather than implementing those integrators. NumPy, pandas and
Matplotlib provide arrays, table output and plotting. Exact tested versions are
in `requirements.txt`, with runtime versions recorded in each run manifest.

The [E-ALPIPE paper](https://pubmed.ncbi.nlm.nih.gov/41321992/) motivates examining
sequential data collection and practical identifiability. It is a conceptual
comparison, not a source of copied code or a claimed reproduction. Our latent
variance criterion is simpler and is described fully in the methods.

The [OMEX curation workflow repository](https://github.com/sys-bio/Developing-a-workflow-for-creating-OMEX-files)
is a related reproducibility effort linked by the primary curation study.
Its code and model-specific output were not incorporated or independently
benchmarked here. No particular uninspected revision is claimed as a verified
dependency. A future cross-engine comparison should pin and inspect the actual
model/simulation bundle before comparing figures.

## What hashes establish

A SHA-256 comparison detects disagreement with the declared bytes. It does not
authenticate an untrusted manifest or identify an author. Code hashes in the
run manifest record the implementation used; source-controlled review and the
fresh numerical reproduction remain necessary. Derived CSVs and figures are
simulations generated here, not literature-derived measurement data.
