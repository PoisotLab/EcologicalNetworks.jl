---
title : Modules detection
author : Timothée Poisot
layout: default
---




In this case study, we will use various techniques to detect the best modules in
a bipartite network. We will use the @TODO network to do so.

````julia
N = convert(BinaryNetwork, fonseca_ganade_1996())
````


<pre class="julia-error">
ERROR: UndefVarError: fonseca_ganade_1996 not defined
</pre>




Specifically, we will try to find the *best* number of modules in a network.
Best, here, means that we are able to find a partition of nodes into modules
that gives the highest value of modularity. We will compare two approaches:
LP-BRIM (**REF**), and BRIM with a random number of initial modules.

## LP-BRIM

## Brim with different numbers of modules

The network has at most <pre class="julia-error">
ERROR: UndefVarError: N not defined
</pre>
 species (on either
levels), so we will use this as an upper bound for networks. We will also say
that in the worse case scenario, the network is made of a single module
