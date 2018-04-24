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

The `setdiff` operation measures the *difference* between two networks -- this
returns the interactions between species that are in the first network but *not*
in the second. For this reason, `setdiff(X,Y)` and `setdiff(Y,X)` *will* have
different outputs.

````julia
u1 = setdiff(Tr[1], Tr[2])
u2 = setdiff(Tr[2], Tr[1])
links.([u1,u2])
````


````
2-element Array{Int64,1}:
 61
 18
````





## Beta-diversity

As explained in **@todo** (following the methodology of @XXXX), dissimilarity is
measured by comparing the size of three sets: interactions unique to either
network, and interactions shared between both networks. With two networks `A`
and `B`, the sets are defined by:

| Set name | Contains                     |
|:---------|:-----------------------------|
| `c`      | elements of `A` not in `B`   |
| `b`      | elements of `B` not in `A`   |
| `a`      | elements both in `A` and `B` |

There are different components of β-diversity, summarized in the table below:

| Function | works on...                    | measures...                                  |
|:---------|:-------------------------------|:---------------------------------------------|
| `βs`     | species                        | the two networks have different species      |
| `βwn`    | all interactions               | the two networks have different interactions |
| `βos`    | interactions of shared species | shared species have the same interactions    |

All of these functions return a `NamedTuple` with three elements: `a`, `b`, and
`c`. These tuples are then accepted as arguments by the β-diversity estimators:

- `whittaker`
- `sorensen`
- `jaccard`
- `gaston`
- `williams`
- `lande`
- `ruggiero`
- `hartekinzig`
- `harrison`

For example, measuring the β-diversity of interactions between shared species of
the first and second networks using the Jaccard and Sorensen measures can be
done with:

````julia
components = βos(Tr[1], Tr[2])
println("Jaccard: $(round(jaccard(components), 2))\tSorensen: $(round(sorensen(components), 2))")
````


````
Jaccard: 0.33	Sorensen: 0.5
````





Note that there is no function to measure `βst`, which in the original
publication is defined as `βwn-βos` -- this can be done *a posteriori* (and
feedback from colleagues has revealed that the interpretation of this value is
not always clear).
