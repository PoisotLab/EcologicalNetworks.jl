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
N = web_of_life("M_PA_003")
````





Let's look at the type of this network:

````julia
typeof(N)
````


````
EcologicalNetwork.BipartiteQuantitativeNetwork{Int64,String}
````





This is a bipartite network, which contains quantitative information about
species interactions, stored as `Int64`. The species are identified by
`String` objects. More information about the types is found in the
[types](/manual/types/) page of the manual.

This is a network with 25 insects and 16 plants. We can check that this
richness is indeed 41::

````julia
richness(N)
````



39



We can check the number of species on either side, using another method for
`richness`:

````julia
richness(N,1)
````



15



The side `1` is the top-level species, and the side `2` is the bottom-level
species. Interactions go from species on side `1` to species on side `2`.

We can look at the species that make up all sides:

````julia
species(N)
````


````
39-element Array{String,1}:
 "Maieta guianensis"         
 "Hirtella physophora"       
 "Tachigali myrmecophila"    
 "Cordia nodosa"             
 "Maieta poeppiggi"          
 "Duroia saccifera"          
 "Tachigali polyphylla"      
 "Tococa bullifera"          
 "Pourouma heterophylla"     
 "Cecropia purpurascens"     
 ⋮                           
 "Azteca sp1 M_PA_001"       
 "Azteca sp6 M_PA_001"       
 "Crematogaster sp1 M_PA_001"
 "Azteca polymorpha"         
 "Crematogaster sp5 M_PA_001"
 "Azteca alfari"             
 "Azteca sp3 M_PA_001"       
 "Azteca sp4 M_PA_001"       
 "Azteca sp5 M_PA_001"
````





Note that this also works for either side:

````julia
species(N,2)
````


````
24-element Array{String,1}:
 "Pheidole minutula"         
 "Allomerus octoarticulatus "
 "Azteca sp2 M_PA_001"       
 "Pseudomyrmex concolor"     
 "Allomerus sp1 M_PA_001"    
 "Pseudomyrmex nigrescens"   
 "Crematogaster sp3 M_PA_001"
 "Camponotus balzanii"       
 "Azteca isthmica"           
 "Crematogaster sp4 M_PA_001"
 ⋮                           
 "Azteca sp1 M_PA_001"       
 "Azteca sp6 M_PA_001"       
 "Crematogaster sp1 M_PA_001"
 "Azteca polymorpha"         
 "Crematogaster sp5 M_PA_001"
 "Azteca alfari"             
 "Azteca sp3 M_PA_001"       
 "Azteca sp4 M_PA_001"       
 "Azteca sp5 M_PA_001"
````





We can look for the presence of interactions between species in a few
different ways. First, we can use their *position* in the network:

````julia
N[3,4]
````



18



But it's probably more intuitive to look at the species by names:

````julia
t3 = species(N,1)[3]
b4 = species(N,2)[4]
t3, b4
````


````
("Tachigali myrmecophila", "Pseudomyrmex concolor")
````





We can access the interaction between these species:

````julia
N[t3,b4]
````



18



The package also offers a way to test the *existence* of an interaction,
regardless of the network type:

````julia
has_interaction(N, t3,b4)
````



true



An interesting thing we can do is extract a subset of the network using
collections of species. We will extract the species belonging to the genus
*Azteca*, and to the genus *Cecropia*:

````julia
all_azteca = filter(x -> contains(x, "Azteca "), species(N,1))
all_cecropia = filter(x -> contains(x, "Cecropia "), species(N,2))
````





Now, we can get a sub-network (the induced subgraph on these nodes):

````julia
M = N[all_azteca, all_cecropia]
````





We can also use slices in a more general way, for example to have all
interactions from the *Azteca* genus:

````julia
N[all_azteca,:]
````


````
EcologicalNetwork.BipartiteQuantitativeNetwork{Int64,String}(Array{Int64}(0
,24), String[], String["Pheidole minutula", "Allomerus octoarticulatus ", "
Azteca sp2 M_PA_001", "Pseudomyrmex concolor", "Allomerus sp1 M_PA_001", "P
seudomyrmex nigrescens", "Crematogaster sp3 M_PA_001", "Camponotus balzanii
", "Azteca isthmica", "Crematogaster sp4 M_PA_001"  …  "Azteca schummani"
, "Azteca sp1 M_PA_001", "Azteca sp6 M_PA_001", "Crematogaster sp1 M_PA_001
", "Azteca polymorpha", "Crematogaster sp5 M_PA_001", "Azteca alfari", "Azt
eca sp3 M_PA_001", "Azteca sp4 M_PA_001", "Azteca sp5 M_PA_001"])
````





Note how extracting by collections of species names returns another network,
of the same type as the parent!

````julia
typeof(M)
````


````
EcologicalNetwork.BipartiteQuantitativeNetwork{Int64,String}
````





We can ask a few questions about the degree of this induced network:

````julia
degree(N)
````


````
Dict{String,Int64} with 39 entries:
  "Pseudomyrmex concolor"      => 2
  "Allomerus octoarticulatus " => 3
  "Allomerus prancei"          => 1
  "Azteca isthmica"            => 4
  "Cecropia purpurascens"      => 3
  "Hirtella myrmecophila"      => 1
  "Cordia nodosa"              => 7
  "Tococa bullifera"           => 6
  "Azteca schummani"           => 2
  "Azteca sp4 M_PA_001"        => 1
  "Crematogaster sp2 M_PA_001" => 2
  "Pseudomyrmex nigrescens"    => 2
  "Azteca sp1 M_PA_001"        => 1
  "Pourouma heterophylla"      => 1
  "Cecropia distachya"         => 1
  "Tachigali polyphylla"       => 3
  "Maieta guianensis"          => 3
  "Azteca sp5 M_PA_001"        => 1
  "Duroia saccifera"           => 4
  ⋮                            => ⋮
````





We can also look at the degree on either sides, for example the degree of
plants (*i.e.* number of insects interacting with them):

````julia
degree(N,2)
````


````
Dict{String,Int64} with 24 entries:
  "Pseudomyrmex concolor"      => 2
  "Allomerus octoarticulatus " => 3
  "Crematogaster sp3 M_PA_001" => 4
  "Azteca isthmica"            => 4
  "Azteca schummani"           => 2
  "Azteca sp4 M_PA_001"        => 1
  "Crematogaster sp2 M_PA_001" => 2
  "Pseudomyrmex nigrescens"    => 2
  "Azteca sp1 M_PA_001"        => 1
  "Azteca sp5 M_PA_001"        => 1
  "Azteca sp6 M_PA_001"        => 1
  "Solenops sp1 M_PA_001"      => 2
  "Azteca sp3 M_PA_001"        => 1
  "Pheidole minutula"          => 3
  "Crematogaster sp4 M_PA_001" => 2
  "Azteca polymorpha"          => 1
  "Camponotus balzanii"        => 1
  "Crematogaster sp1 M_PA_001" => 2
  "Azteca sp2 M_PA_001"        => 3
  ⋮                            => ⋮
````


