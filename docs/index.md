---
title: EcologicalNetwork.jl
layout: default
---

This `julia` package provides a common interface to analyze all types of data on
ecological networks. It is designed to be general, easy to expand, and work on
bipartite/unipartite as well as deterministic/quantitative/probabilistic
networks. It is compatible with Julia v0.6.

[![Join the chat at https://gitter.im/PoisotLab/EcologicalNetwork.jl](https://badges.gitter.im/PoisotLab/EcologicalNetwork.jl.svg)](https://gitter.im/PoisotLab/EcologicalNetwork.jl?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

This package is *very* opinionated about the right way to analyze ecological
networks - fortunately, we have documented (and justified) these opinions in an
extensive review by @DelBes17 (all the references in this documentation can be
clicked to see the article title and a link). We recommend reading this
manuscript, as it lists the measures implemented here, details their
interpretation, and justifies some best practices.

Almost all of the measures for probabilistic networks can be found in the
original paper by @PoiCir16. Some measures are in the package only, as they have
been derived after we published the original paper.

The functions in this package are robustly tested (and we also run entire case
studies as part of our testing strategy to make sure it all fits snugly
together). We do not guarantee that there are no bugs or edge-cases in the code,
but our aim is to provide a robust, user-friendly, and general platform to
analyze ecological networks following the very best standards possible.

## What the package is (and is not)

This package provides *base* function to perform the most common network
analyses in ecological research. Your favourite measure may not be implemented,
for two reasons. We may not use it that often, but realize it is useful - we
would be glad to add it. Or we have solid evidence that it should not be used at
all, and we will not add it to the package. But the package is designed to be
extendable. Because there are a lot of functions to do very basic things, it is
relatively easy to build your own measures.

This package is *not* a collection of wrappers. In the previous versions, we had
single functions to do an entire modularity analysis, or NHST, or networks
permutations. Then in the course of actually using it for research, we realized
that almost everything we did required minute changes from these functions. As a
result, we do not provide wrappers to perform common tasks. Instead, we provide
a series of building blocks to be combined into your own pipeline.

## How to read this documentation

It is advised you start reading some of the "Use cases": they will give you a
feel about the syntax of the package, and have been inspired either by published
papers, or by tasks we had to solve using this package. You can think of these
use cases as templates for a start-to-finish analysis, including data
visualization.

The "Manual" pages give a more in-depth presentation of specific applications
and families of measures. Throughout the documentation, we have linked the
relevant papers, and discuss what we believe are the best practices. We do not
suggest you read this documentation as an analysis to the introduction of
ecological network, but be prepared to find some discussion of the measures (and
not only of the code).

Every page of this documentation is automatically generated. This ensures that
you can copy the code blocks with `INPUT` at the top, and get the same result
(with the exception of results that involved some stochasticity).

## Getting started

Install the package with

~~~ julia
Pkg.add("EcologicalNetwork")
~~~

## How to cite the code

Please refer to this DOI: [![DOI](https://zenodo.org/badge/25148478.svg)](https://zenodo.org/badge/latestdoi/25148478)
