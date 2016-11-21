# Measures of the structure of ecological networks

[![Join the chat at https://gitter.im/PoisotLab/EcologicalNetwork.jl](https://badges.gitter.im/PoisotLab/EcologicalNetwork.jl.svg)](https://gitter.im/PoisotLab/EcologicalNetwork.jl?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
[![GitHub tag](https://img.shields.io/github/tag/PoisotLab/EcologicalNetwork.jl.svg)]()
[![DOI](https://zenodo.org/badge/25148478.svg)](https://zenodo.org/badge/latestdoi/25148478)

## Current version

[![Build Status](https://travis-ci.org/PoisotLab/EcologicalNetwork.jl.svg?branch=master)](https://travis-ci.org/PoisotLab/EcologicalNetwork.jl)
[![Coverage Status](https://coveralls.io/repos/PoisotLab/EcologicalNetwork.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/PoisotLab/EcologicalNetwork.jl?branch=master)
[![codecov.io](http://codecov.io/github/PoisotLab/EcologicalNetwork.jl/coverage.svg?branch=master)](http://codecov.io/github/PoisotLab/EcologicalNetwork.jl?branch=master)
[![Documentation Status](https://readthedocs.org/projects/ecologicalnetworkjl/badge/?version=latest)](https://readthedocs.org/projects/ecologicalnetworkjl/?badge=latest)

## Development version

[![Build Status](https://travis-ci.org/PoisotLab/EcologicalNetwork.jl.svg?branch=dev)](https://travis-ci.org/PoisotLab/EcologicalNetwork.jl)
[![Coverage Status](https://coveralls.io/repos/PoisotLab/EcologicalNetwork.jl/badge.svg?branch=dev&service=github)](https://coveralls.io/github/PoisotLab/EcologicalNetwork.jl?branch=dev)
[![codecov.io](http://codecov.io/github/PoisotLab/EcologicalNetwork.jl/coverage.svg?branch=dev)](http://codecov.io/github/PoisotLab/EcologicalNetwork.jl?branch=dev)
[![Documentation Status](https://readthedocs.org/projects/ecologicalnetworkjl/badge/?version=dev)](http://ecologicalnetworkjl.readthedocs.io/en/dev/?badge=dev)

# Introduction

This `Julia` module implements a set of measures and utilities to work on
ecological networks, with an emphasis on probabilistic ones. The measures
are **not** designed to work on *quantitative* interaction networks,
*i.e.* those in which the strength of the interaction is known.

It is companion code to the paper by Poisot et al., accepted for publication in
*Methods in Ecology and Evolution*. A preprint of the paper can be accessed on
[bioRxiv][brxpaper].

[brxpaper]: http://biorxiv.org/content/early/2015/03/13/016485

## Installation

``` julia
Pkg.add("EcologicalNetwork")
```

## Types

The package has four basic types of networks: `BipartiteProbaNetwork`,
`BipartiteNetwork`, `UnipartiteProbaNetwork`, and `UnipartiteNetwork`. All
of these types are in fact `Array`s with two dimensions. The number of types
is used to take advantage of Julia's multiple dispatch ability: the function
names are the same regardless of the network type.

A bit of information for those of you wanting to add functionalities: all of
these types are also accessible through `EcoNetwork` (all types), `Bipartite`
and `Unipartite` (all bipartite and unipartite, regardless of the probabilistic
or deterministic state of interactions), and `ProbabilisticNetwork` and
`DeterministicNetwork` (same thing). In the long term, this will make the
addition of *e.g.* a `BipartiteQuantiNetwork` and `UnipartiteQuantiNetwork`
easier.
