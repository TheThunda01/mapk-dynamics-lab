# A bounded review behind this benchmark

## Question and scope

Which small, openly reusable signaling model supports an inspectable comparison
of sequential virtual observations, and what evidence limits interpretation of
that comparison? The review focused on model equations, mechanisms absent from
the compact model, recent observation-design work and computational reproducibility.
It was a rapid, targeted review conducted on 2026-10-20, not a systematic review
of all MAPK biology or all experimental-design algorithms.

## Search record

The searches below are the preserved development record, not a claim that the literature search was rerun for the editorial review. The [21 October UTC source recheck](reference-audit.json) records current metadata, inspected passages and access limits. It does not add a new systematic-search yield.

The machine-readable [search log](search-log.json) records seven actual PubMed
queries, parameters, returned IDs, pagination limits and decisions. Together
they returned 19 unique records, all screened at title/abstract level: six were
retained, four as direct sources and two as feasibility/method context; thirteen
were excluded. Direct lookups of known PMIDs did not increase those counts.

An initial broad MAPK/experimental-design query reported 71 results. Only its
first eight were retrieved; they were largely off-topic biological/clinical
applications. We refined the query instead of claiming to screen the remaining
63. A focused MAPK/identifiability query then returned zero records. Author,
method and title queries supplied more useful sources. The exact contributor
queries are also retained in [contributor-searches.json](contributor-searches.json).

The original model and sequestration papers were appraised through abstracts
and model context. For E-ALPIPE, the abstract and the first 18,000 characters of
the PMC article were inspected; the remainder was not critically appraised.
The curation study's publisher methods/results and citation metadata were
inspected. No paper here received a formal risk-of-bias assessment. Official
model files, license and numerical documentation were checked separately.

## What the sources support

| Source | Supported role | What it does not establish here |
|---|---|---|
| [Kholodenko (2000)](https://pubmed.ncbi.nlm.nih.gov/10712587/) and the pinned BioModels encoding | A compact feedback cascade can produce oscillatory behavior under specified assumptions | That every MAPK pathway oscillates, or that this run reproduces an original figure |
| [Blüthgen et al. (2006)](https://pubmed.ncbi.nlm.nih.gov/16478465/) | Explicit sequestration can change sensitivity and remove feedback-associated oscillations in this model class | A quantitative correction for this particular implementation without implementing their extended model |
| [Liu et al. (2025)](https://pubmed.ncbi.nlm.nih.gov/41321992/) | Sequential data collection is a reasonable computational question for practical identifiability, demonstrated in synthetic settings | Performance of our simpler variance rule, or full-model identifiability |
| [Xu and Smith (2024)](https://pubmed.ncbi.nlm.nih.gov/39636894/) | Model encodings and simulation instructions need explicit reproducibility checks | Independent validation of our implementation or exact original-figure reproduction |
| [Huang and Ferrell (1996)](https://pubmed.ncbi.nlm.nih.gov/8816754/) | Classic background on cascade ultrasensitivity; an alternative larger model considered during feasibility | Evidence that the selected model is uniquely appropriate |
| [Gevertz and Kareva (2024)](https://pubmed.ncbi.nlm.nih.gov/38184643/) | Additional primary context connecting design and identifiability | A transfer of results from their different model to this MAPK benchmark |

The official BioModels repository supplies the actual licensed computational
input. SciPy's versioned solver documentation supplies the numerical API and
tolerance semantics. Those are technical sources, not independent biological
studies.

## Changes made

The review led to a smaller, auditable model instead of a larger cascade.
We preserved exact source bytes and translated the ten rates, with independent
source-MathML and conservation-reduced checks. We included random and fixed
comparators, common candidate-indexed noise, saved posterior weights and an
independent output replay. None of the papers' reported algorithm performance
was imported as if it were a result of this project.

The contrary sequestration evidence changed the interpretation: oscillations
are explicitly conditional model outputs. The distinction between a finite-grid
posterior and full identifiability motivated both the narrow wording and the
off-grid stress scenario. The variance rule is labeled a heuristic rather than
an exact information-theoretic optimum.

## Remaining work

Priority extensions are testing additional off-grid truths and noise models,
checking results with a separately pinned general SBML engine, and comparing a
licensed explicit-complex model. Matching a publication figure would require
verifying the corresponding simulation settings and any curation changes.
Real-data work would additionally need suitable measurements and a defensible
observation model. These are future tasks, not completed validations.

## Limits of this review

PubMed and targeted official-source lookups can miss relevant mathematical,
control-theory and software literature. The date window for recent method
queries was 2022-01-01 through 2026-10-20; classic sources were retrieved without
that restriction. The retained set is small and purpose-selected, and full texts
were not comprehensively appraised. No evidence synthesis or search-completeness
claim is made. Search counts describe what was actually returned and screened,
not the size of the underlying scientific literature.
