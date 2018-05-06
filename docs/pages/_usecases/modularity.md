---
title : Modules detection
author : Timothée Poisot
layout: default
---




In this case study, we will use various techniques to detect the best modules in
a bipartite network. We will use the @TODO network to do so.

````julia
N = convert(BinaryNetwork, web_of_life("M_PA_003"))
````





Specifically, we will try to find the *best* number of modules in a network.
Best, here, means that we are able to find a partition of nodes into modules
that gives the highest value of modularity. We will compare two approaches:
LP-BRIM (**REF**), and BRIM with a random number of initial modules.

## LP-BRIM

## Brim with different numbers of modules

The network has at most 
24 species (on either
levels), so we will use this as an upper bound for networks. We will also say
that in the worse case scenario, the network is made of a single module
