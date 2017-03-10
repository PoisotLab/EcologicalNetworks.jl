# Measures of the structure of ecological networks

[![Join the chat at https://gitter.im/PoisotLab/EcologicalNetwork.jl](https://badges.gitter.im/PoisotLab/EcologicalNetwork.jl.svg)](https://gitter.im/PoisotLab/EcologicalNetwork.jl?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
[![GitHub tag](https://img.shields.io/github/tag/PoisotLab/EcologicalNetwork.jl.svg)]()
[![DOI](https://zenodo.org/badge/25148478.svg)](https://zenodo.org/badge/latestdoi/25148478)
[![](https://img.shields.io/badge/docs-stable-blue.svg)](https://PoisotLab.github.io/EcologicalNetwork.jl/stable)
[![license](https://img.shields.io/github/license/PoisotLab/EcologicalNetwork.jl.svg)]()

[![EcologicalNetwork](http://pkg.julialang.org/badges/EcologicalNetwork_0.5.svg)](http://pkg.julialang.org/?pkg=EcologicalNetwork)
[![EcologicalNetwork](http://pkg.julialang.org/badges/EcologicalNetwork_0.6.svg)](http://pkg.julialang.org/?pkg=EcologicalNetwork)

## Latest version

[![Build Status](https://travis-ci.org/PoisotLab/EcologicalNetwork.jl.svg?branch=master)](https://travis-ci.org/PoisotLab/EcologicalNetwork.jl)
[![Coverage Status](https://coveralls.io/repos/PoisotLab/EcologicalNetwork.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/PoisotLab/EcologicalNetwork.jl?branch=master)
[![codecov.io](http://codecov.io/github/PoisotLab/EcologicalNetwork.jl/coverage.svg?branch=master)](http://codecov.io/github/PoisotLab/EcologicalNetwork.jl?branch=master)
[![](https://img.shields.io/badge/docs-latest-blue.svg)](https://PoisotLab.github.io/EcologicalNetwork.jl/latest)

# Introduction

This *julia* package implements a set of measures and utilities to work on
ecological networks, with an emphasis on probabilistic ones. Most of the
work on probabilistic ecological networks comes from:

Poisot, Timothée, Alyssa R. Cirtwill, Kévin Cazelles, Dominique Gravel,
Marie-Josée Fortin, and Daniel B. Stouffer. “The Structure of Probabilistic
Networks.” Edited by Jana Vamosi. Methods in Ecology and Evolution 7, no. 3
(March 2016): 303–12. doi:10.1111/2041-210X.12468.

The package implements most of the measures discussed in the following preprint:

Delmas, Eva, Mathilde Besson, Marie-Helene Brice, Laura Burkle, Giulio V. Dalla
Riva, Marie-Josée Fortin, Dominique Gravel, et al. “Analyzing Ecological
Networks of Species Interactions.” bioRxiv, February 28, 2017, 112540.
doi:10.1101/112540.

## Installation

To get the `stable` version:

~~~ julia
Pkg.add("EcologicalNetwork")
~~~

To get the `lastest` version (after `Pkg.add`):

~~~ julia
Pkg.checkout("EcologicalNetwork")
~~~

## Informations for `dev` branch

[![Build Status](https://travis-ci.org/PoisotLab/EcologicalNetwork.jl.svg?branch=dev)](https://travis-ci.org/PoisotLab/EcologicalNetwork.jl)
[![Coverage Status](https://coveralls.io/repos/github/PoisotLab/EcologicalNetwork.jl/badge.svg?branch=dev)](https://coveralls.io/github/PoisotLab/EcologicalNetwork.jl?branch=dev)
