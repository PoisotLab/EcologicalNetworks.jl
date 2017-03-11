# Measures of the structure of ecological networks

[![Join the chat at https://gitter.im/PoisotLab/EcologicalNetwork.jl](https://badges.gitter.im/PoisotLab/EcologicalNetwork.jl.svg)](https://gitter.im/PoisotLab/EcologicalNetwork.jl?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

This *julia* package implements a set of measures and utilities to work on
ecological networks, with an emphasis on probabilistic ones. Most of the
work on probabilistic ecological networks comes from:

> Poisot, T., Cirtwill, A. R., Cazelles, K., Gravel, D., Fortin, M.-J. and
> Stouffer, D. B. (2016), The structure of probabilistic networks. Methods Ecol
> Evol, 7: 303–312. doi:10.1111/2041-210X.12468

## Project overview

<table>
  <tr>
    <td rowspan="2">
    <b>Problem</b>
    <p>There is no software package to analyze <em>all</em> types of ecological interactions (food webs, bipartite networks, probabilistic interactions, quantitative interactions, ...).</p>
    <p>The most complete packages are difficult to contribute to because they do not have a consolidated code base.</p>
    </td>
    <td>
    <b>Solution</b>
    <p>We provide a common interface to multiple types of ecological interaction data, which is easy to expand.</p>
    </td>
    <td colspan="3"><b>Unique value proposition</b>
    <p>Same interface no matter what the data type is.</p>
    <p>Easy to expand thanks to the type system.</p>
    <p>Well tested and documented.</p>
    <p>Selection of the most robust measures after a <a href="http://biorxiv.org/content/early/2017/02/28/112540">literature review</a>.</p>
    </td>
  </tr>
  <tr>
    <td>
    <b>Metrics for success</b>
    <p>Number of users / downloads.</p>
    <p>Citations / software paper.</p>
    </td>
    <td colspan="2">
      <b>User profiles</b>
      <p>Ecologists analyzing data on ecological networks.</p>
      <p>Students.</p>
    </td>
    <td>
      <b>User channels</b>
      <p>Conferences.</p>
      <p><a href="https://gitter.im/PoisotLab/EcologicalNetwork.jl?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge">Gitter</a>.</p>
    </td>
  </tr>
  <tr>
    <td colspan="2"><b>Resources</b>
    <p>GitHub account.</p>
    <p>Hosting for the documentation.</p>
    </td>
    <td colspan="2"><b>Contributor profiles</b>
    <p>More advanced users.</p>
    <p>Methods developers.</p>
    </td>
    <td>
    <b>Contributors channels</b>
    <p><a href="https://gitter.im/PoisotLab/EcologicalNetwork.jl?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge">Gitter</a>.</p>
    </td>
  </tr>
</table>

## Installation

To get the `stable` version:

~~~ julia
Pkg.add("EcologicalNetwork")
~~~

To get the `lastest` version (after `Pkg.add`):

~~~ julia
Pkg.checkout("EcologicalNetwork")
~~~

# How's the code doing?

## Released version

[![GitHub tag](https://img.shields.io/github/tag/PoisotLab/EcologicalNetwork.jl.svg)]()
[![DOI](https://zenodo.org/badge/25148478.svg)](https://zenodo.org/badge/latestdoi/25148478)
[![license](https://img.shields.io/github/license/PoisotLab/EcologicalNetwork.jl.svg)]()

[![](https://img.shields.io/badge/docs-stable-blue.svg)](https://PoisotLab.github.io/EcologicalNetwork.jl/stable)

[![EcologicalNetwork](http://pkg.julialang.org/badges/EcologicalNetwork_0.5.svg)](http://pkg.julialang.org/?pkg=EcologicalNetwork)
[![EcologicalNetwork](http://pkg.julialang.org/badges/EcologicalNetwork_0.6.svg)](http://pkg.julialang.org/?pkg=EcologicalNetwork)

## On `master`

[![Build Status](https://travis-ci.org/PoisotLab/EcologicalNetwork.jl.svg?branch=master)](https://travis-ci.org/PoisotLab/EcologicalNetwork.jl)
[![Coverage Status](https://coveralls.io/repos/PoisotLab/EcologicalNetwork.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/PoisotLab/EcologicalNetwork.jl?branch=master)
[![codecov.io](http://codecov.io/github/PoisotLab/EcologicalNetwork.jl/coverage.svg?branch=master)](http://codecov.io/github/PoisotLab/EcologicalNetwork.jl?branch=master)
[![](https://img.shields.io/badge/docs-latest-blue.svg)](https://PoisotLab.github.io/EcologicalNetwork.jl/latest)

## On `dev`

[![Build Status](https://travis-ci.org/PoisotLab/EcologicalNetwork.jl.svg?branch=dev)](https://travis-ci.org/PoisotLab/EcologicalNetwork.jl)
[![Coverage Status](https://coveralls.io/repos/github/PoisotLab/EcologicalNetwork.jl/badge.svg?branch=dev)](https://coveralls.io/github/PoisotLab/EcologicalNetwork.jl?branch=dev)
