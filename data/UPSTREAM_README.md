# BIOMD0000000010: BIOMD0000000010

## Installation

Download this repository, and install with distutils

`python setup.py install`

Or, install using pip

`pip install git+https://github.com/biomodels/BIOMD0000000010.git`

To install a specific version (in this example, from the 2014-09-16 BioModels release)

`pip install git+https://github.com/biomodels/BIOMD0000000010.git@20140916`

## Usage

Importing the model package.

`import BIOMD0000000010 as model`

Get the SBML string from the model

`print model.sbmlString`

If [python-libsbml](https://pypi.python.org/pypi/python-libsbml) bindings are
installed, the libsbml.SBMLDocument object is also accessible

`model.sbml`


# Model Notes


Kholodenko2000 - Ultrasensitivity and negative feedback bring oscillations in
MAPK cascade

The combination of ultrasensitivity and negative feedback bring sustained
oscillations in the mitogen-activated protein kinase cascades.

This model is described in the article:

[Negative feedback and ultrasensitivity can bring about oscillations in the
mitogen-activated protein kinase
cascades.](http://identifiers.org/pubmed/10712587)

Kholodenko BN

Eur. J. Biochem. 2000; 267(6):1583-8

Abstract:

Functional organization of signal transduction into protein phosphorylation
cascades, such as the mitogen-activated protein kinase (MAPK) cascades,
greatly enhances the sensitivity of cellular targets to external stimuli. The
sensitivity increases multiplicatively with the number of cascade levels, so
that a tiny change in a stimulus results in a large change in the response,
the phenomenon referred to as ultrasensitivity. In a variety of cell types,
the MAPK cascades are imbedded in long feedback loops, positive or negative,
depending on whether the terminal kinase stimulates or inhibits the activation
of the initial level. Here we demonstrate that a negative feedback loop
combined with intrinsic ultrasensitivity of the MAPK cascade can bring about
sustained oscillations in MAPK phosphorylation. Based on recent kinetic data
on the MAPK cascades, we predict that the period of oscillations can range
from minutes to hours. The phosphorylation level can vary between the base
level and almost 100% of the total protein. The oscillations of the
phosphorylation cascades and slow protein diffusion in the cytoplasm can lead
to intracellular waves of phospho-proteins.

This model is hosted on [BioModels Database](http://www.ebi.ac.uk/biomodels/)
and identified by:
[BIOMD0000000010](http://identifiers.org/biomodels.db/BIOMD0000000010) .

To cite BioModels Database, please use: [BioModels Database: An enhanced,
curated and annotated resource for published quantitative kinetic
models](http://identifiers.org/pubmed/20587024) .

To the extent possible under law, all copyright and related or neighbouring
rights to this encoded model have been dedicated to the public domain
worldwide. Please refer to [CC0 Public Domain
Dedication](http://creativecommons.org/publicdomain/zero/1.0/) for more
information.


