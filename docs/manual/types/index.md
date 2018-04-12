---
title : Understanding the type system
author : Timothée Poisot
date : 11th April 2018
layout: default
---

````julia
using EcologicalNetwork
using Base.Test

N = fonseca_ganade_1996()
````




The type of networks have a hierarchy between them. We can test that this
network is bipartite:

````julia
@test typeof(N) <: AbstractBipartiteNetwork
````


````
Test Passed
````




We can also check that it is quantitative:

````julia
@test typeof(N) <: QuantitativeNetwork
````


````
Test Passed
````




Finally, we can also check that it is not probabilistic:

````julia
@test typeof(N) <: DeterministicNetwork
````


````
Test Passed
````


