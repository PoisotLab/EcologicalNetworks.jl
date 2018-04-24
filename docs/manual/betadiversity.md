---
title : Beta-diversity
author : Timothée Poisot
date : 11th April 2018
layout: default
---




Measuring network dissimilarity (β-diversity) relies on a small number of
operations, as detailed in **TODO**. These functions currently work *only* on
binary networks. We will use the Canaria islands data to illustrate how they
work.

````julia
Tr = map(n -> convert(BinaryNetwork, n), trojelsgaard_et_al_2014())
````





Most of the underlying operations re-use the `julia` functions to operate on
sets: `union`, `intersect`, and `setdiff`. The output of these functions is
relatively similar to the decisions made by `igraph`.

## Addition of networks

The `union` function will return the *superposition* of two networks, *i.e.* the
union of both their species and interactions.

````julia
first_two = union(Tr[1], Tr[2])
println("N₁: $(richness(Tr[1]))\tN₂: $(richness(Tr[2]))\tN₁₊₂: $(richness(first_two))")
````


````
N₁: 63	N₂: 54	N₁₊₂: 108
````





It is possible to get the *sum* of a collection of networks through a `reduce`
operation:

````julia
metaweb = reduce(union, Tr)
println("̂N: $(mean(richness.(Tr)))\t∑N: $(richness(metaweb))")
````


````
̂N: 51.0	∑N: 274
````





## Common elements in networks

The `intersect` function will return a network made of *shared interactions*
between *shared species*. This introduces an important point: shared species
that have no shared interactions will be present in this output:

````julia
i1 = intersect(Tr[1], Tr[2])
println(richness(i1))
````


````
9
````





For this reason, it is possible to pass this output through the `simplify`
function to remove species with a degree of 0:

````julia
println(richness(simplify(i1)))
````


````
4
````





The `simplify` function will change the richness, but not the number of
interactions.

## Differences between networks

## Beta-diversity
