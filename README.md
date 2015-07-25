# Measures of the structure of ecological networks

[![Build Status](https://travis-ci.org/PoisotLab/EcologicalNetwork.jl.svg?branch=master)](https://travis-ci.org/PoisotLab/EcologicalNetwork.jl)
[![Coverage Status](https://coveralls.io/repos/PoisotLab/EcologicalNetwork.jl/badge.svg)](https://coveralls.io/r/PoisotLab/EcologicalNetwork.jl)
[![codecov.io](http://codecov.io/github/PoisotLab/EcologicalNetwork.jl/coverage.svg?branch=master)](http://codecov.io/github/PoisotLab/EcologicalNetwork.jl?branch=master)
[![DOI](https://zenodo.org/badge/doi/10.5281/zenodo.16578.svg)](http://dx.doi.org/10.5281/zenodo.16578)
[![Documentation Status](https://readthedocs.org/projects/probabilisticnetworkjl/badge/?version=latest)](http://probabilisticnetworkjl.readthedocs.org/en/latest/)


This `Julia` module implements a set of measures and utilities to work on
ecological networks, with an emphasis on probabilistic ones. The measures
are **not** designed to work on *quantitative* interaction networks,
*i.e.* those in which the strength of the interaction is knwown.

It is companion code to the paper by Poisot et al., currently *under revision*
for *Methods in Ecology and Evolution*. A preprint of the paper can be accessed
on [bioRxiv][brxpaper].

[brxpaper]: http://biorxiv.org/content/early/2015/03/13/016485

## Installation

``` julia
Pkg.add("EcologicalNetwork")
```
