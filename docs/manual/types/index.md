---
title : Understanding the type system
author : Timothée Poisot
date : 11th April 2018
layout: default
---



`EcologicalNetwork` uses a series of types to represent networks. Before we
dig in, it is important to get a sense of what the types can do for you. The
type of a network is used to define the types of things you can do to it. For
example, the correct way to measure nestedness changes depending on if the
network is quantitative or binary. Picking the correct network is important.



## Network types



There are three types of networks 

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


