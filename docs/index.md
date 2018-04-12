---
title: EcologicalNetwork.jk
layout: default
---

# EcologicalNetwork.jl

This `julia` package provides a common interface to analyze all types of data
on ecological networks. It is designed to be general, easy to expand, and work
on bipartite/unipartite as well as deterministic/quantitative/probabilistic
networks. The development version is compatible with `julia` 0.6.

[![](https://img.shields.io/badge/docs-stable-blue.svg)](https://PoisotLab.github.io/EcologicalNetwork.jl/stable)
[![](https://img.shields.io/badge/docs-latest-blue.svg)](https://PoisotLab.github.io/EcologicalNetwork.jl/latest)
[![Join the chat at https://gitter.im/PoisotLab/EcologicalNetwork.jl](https://badges.gitter.im/PoisotLab/EcologicalNetwork.jl.svg)](https://gitter.im/PoisotLab/EcologicalNetwork.jl?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

You can read more about the selection of measures in:

> Delmas, E. et al. Analyzing ecological networks of species interactions.
> bioRxiv 112540 (2017). doi:10.1101/112540

and about probabilistic networks in:

> Poisot, T. et al. The structure of probabilistic networks. Methods in Ecology
> and Evolution 7, 303–312 (2016). doi: 10.1111/2041-210X.12468

## Getting started

To get the `stable` version:

~~~ julia
Pkg.add("EcologicalNetwork")
~~~

To stay up to date on more recent features, you may want to use the `latest`
version -- it will always be stable:

~~~ julia
Pkg.clone("https://github.com/PoisotLab/EcologicalNetwork.jl")
~~~

## How's the code doing?

### Released version

[![DOI](https://zenodo.org/badge/25148478.svg)](https://zenodo.org/badge/latestdoi/25148478)
[![license](https://img.shields.io/badge/license-MIT%20%22Expat%22-yellowgreen.svg)](https://github.com/PoisotLab/EcologicalNetwork.jl/blob/master/LICENSE.md)

[![GitHub tag](https://img.shields.io/github/tag/PoisotLab/EcologicalNetwork.jl.svg)]()
[![GitHub issues](https://img.shields.io/github/issues/PoisotLab/EcologicalNetwork.jl.svg)]()
[![GitHub pull requests](https://img.shields.io/github/issues-pr/PoisotLab/EcologicalNetwork.jl.svg)]()

[![EcologicalNetwork](http://pkg.julialang.org/badges/EcologicalNetwork_0.4.svg)](http://pkg.julialang.org/?pkg=EcologicalNetwork)
[![EcologicalNetwork](http://pkg.julialang.org/badges/EcologicalNetwork_0.5.svg)](http://pkg.julialang.org/?pkg=EcologicalNetwork)
[![EcologicalNetwork](http://pkg.julialang.org/badges/EcologicalNetwork_0.6.svg)](http://pkg.julialang.org/?pkg=EcologicalNetwork)

### On `master`

[![Build Status](https://travis-ci.org/PoisotLab/EcologicalNetwork.jl.svg?branch=master)](https://travis-ci.org/PoisotLab/EcologicalNetwork.jl)
[![Coverage Status](https://coveralls.io/repos/PoisotLab/EcologicalNetwork.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/PoisotLab/EcologicalNetwork.jl?branch=master)
[![codecov.io](http://codecov.io/github/PoisotLab/EcologicalNetwork.jl/coverage.svg?branch=master)](http://codecov.io/github/PoisotLab/EcologicalNetwork.jl?branch=master)

### On `develop`

[![Build Status](https://travis-ci.org/PoisotLab/EcologicalNetwork.jl.svg?branch=develop)](https://travis-ci.org/PoisotLab/EcologicalNetwork.jl)
[![Coverage Status](https://coveralls.io/repos/github/PoisotLab/EcologicalNetwork.jl/badge.svg?branch=develop)](https://coveralls.io/github/PoisotLab/EcologicalNetwork.jl?branch=develop)
[![codecov.io](http://codecov.io/github/PoisotLab/EcologicalNetwork.jl/coverage.svg?branch=develop)](http://codecov.io/github/PoisotLab/EcologicalNetwork.jl?branch=develop)
