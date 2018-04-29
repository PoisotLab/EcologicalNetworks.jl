---
title : Accessing species and interactions
author : Timothée Poisot
date : 11th April 2018
layout: default
slug: accessing
---





The purpose of this case study is to illustrate the ways to manipulate the
network objects. We start by loading a network, in this case the one by Fonseca &
Ganade (1996). This is a bipartite network.

````julia
N = fonseca_ganade_1996()
````


<pre class="julia-error">
ERROR: UndefVarError: fonseca_ganade_1996 not defined
</pre>




Let's look at the type of this network:

````julia
typeof(N)
````


<pre class="julia-error">
ERROR: UndefVarError: N not defined
</pre>




This is a bipartite network, which contains quantitative information about
species interactions, stored as `Int64`. The species are identified by
`String` objects. More information about the types is found in the
[types](/manual/types/) page of the manual.

This is a network with 25 insects and 16 plants. We can check that this
richness is indeed 41::

````julia
richness(N)
````


<pre class="julia-error">
ERROR: UndefVarError: N not defined
</pre>




We can check the number of species on either side, using another method for
`richness`:

````julia
richness(N,1)
````


<pre class="julia-error">
ERROR: UndefVarError: N not defined
</pre>




The side `1` is the top-level species, and the side `2` is the bottom-level
species. Interactions go from species on side `1` to species on side `2`.

We can look at the species that make up all sides:

````julia
species(N)
````


<pre class="julia-error">
ERROR: UndefVarError: N not defined
</pre>




Note that this also works for either side:

````julia
species(N,2)
````


<pre class="julia-error">
ERROR: UndefVarError: N not defined
</pre>




We can look for the presence of interactions between species in a few
different ways. First, we can use their *position* in the network:

````julia
N[3,4]
````


<pre class="julia-error">
ERROR: UndefVarError: N not defined
</pre>




But it's probably more intuitive to look at the species by names:

````julia
t3 = species(N,1)[3]
````


<pre class="julia-error">
ERROR: UndefVarError: N not defined
</pre>


````julia
b4 = species(N,2)[4]
````


<pre class="julia-error">
ERROR: UndefVarError: N not defined
</pre>


````julia
t3, b4
````


<pre class="julia-error">
ERROR: UndefVarError: t3 not defined
</pre>




We can access the interaction between these species:

````julia
N[t3,b4]
````


<pre class="julia-error">
ERROR: UndefVarError: N not defined
</pre>




The package also offers a way to test the *existence* of an interaction,
regardless of the network type:

````julia
has_interaction(N, t3,b4)
````


<pre class="julia-error">
ERROR: UndefVarError: N not defined
</pre>




An interesting thing we can do is extract a subset of the network using
collections of species. We will extract the species belonging to the genus
*Azteca*, and to the genus *Cecropia*:

````julia
all_azteca = filter(x -> contains(x, "Azteca "), species(N,1))
````


<pre class="julia-error">
ERROR: UndefVarError: N not defined
</pre>


````julia
all_cecropia = filter(x -> contains(x, "Cecropia "), species(N,2))
````


<pre class="julia-error">
ERROR: UndefVarError: N not defined
</pre>




Now, we can get a sub-network (the induced subgraph on these nodes):

````julia
M = N[all_azteca, all_cecropia]
````


<pre class="julia-error">
ERROR: UndefVarError: N not defined
</pre>




We can also use slices in a more general way, for example to have all
interactions from the *Azteca* genus:

````julia
N[all_azteca,:]
````


<pre class="julia-error">
ERROR: UndefVarError: N not defined
</pre>




Note how extracting by collections of species names returns another network,
of the same type as the parent!

````julia
typeof(M)
````


<pre class="julia-error">
ERROR: UndefVarError: M not defined
</pre>




We can ask a few questions about the degree of this induced network:

````julia
degree(N)
````


<pre class="julia-error">
ERROR: UndefVarError: N not defined
</pre>




We can also look at the degree on either sides, for example the degree of
plants (*i.e.* number of insects interacting with them):

````julia
degree(N,2)
````


<pre class="julia-error">
ERROR: UndefVarError: N not defined
</pre>

