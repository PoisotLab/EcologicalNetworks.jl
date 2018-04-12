---
title : Case study 1 - generalities about the package
author : Timothée Poisot
date : 11th April 2018
layout: default
---



# Accessing species interactions



The purpose of this case study is to illustrate the ways to manipulate the
network objects. First, let's load the package:

````julia
using EcologicalNetwork
````





We start by loading a network, in this case the one by Fonseca & Ganade
(1996). This is a bipartite network.

````julia
N = fonseca_ganade_1996()
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



41



We can check the number of species on either side, using another method for
`richness`:

````julia
richness(N,1)
````



25


The side `1` is the top-level species, and the side `2` is the bottom-level
species. Interactions go from species on side `1` to species on side `2`.



We can look at the species that make up all sides:

````julia
species(N)
````


````
41-element Array{String,1}:
 "Camponotus balzanii"          
 "Azteca alfari"                
 "Azteca isthmica"              
 "Azteca aff. Isthmica"         
 "Allomerus D"                  
 "Allomerus prancei"            
 "Allomerus aff. Octoarticulata"
 "Solenops A"                   
 "Allomerus auripunctata"       
 "Crematogaster B"              
 ⋮                              
 "Duroia saccifera"             
 "Cordia nodosa"                
 "Cordia aff. Nodosa"           
 "Tococa bullifera"             
 "Maieta guianensis"            
 "Maieta poeppiggi"             
 "Tachigali polyphylla"         
 "Tachigali myrmecophila"       
 "Amaioua aff. Guianensis"
````




Note that this also works for either side:

````julia
species(N,2)
````


````
16-element Array{String,1}:
 "Cecropia purpuracens"   
 "Cecropia concolor"      
 "Cecropia distachya"     
 "Cecropia ficifolia"     
 "Pouruma heterophylla"   
 "Hirtella myrmecophila"  
 "Hirtella physophora"    
 "Duroia saccifera"       
 "Cordia nodosa"          
 "Cordia aff. Nodosa"     
 "Tococa bullifera"       
 "Maieta guianensis"      
 "Maieta poeppiggi"       
 "Tachigali polyphylla"   
 "Tachigali myrmecophila" 
 "Amaioua aff. Guianensis"
````




We can look for the presence of interactions between species in a few
different ways. First, we can use their *position* in the network:

````julia
N[3,4]
````



1


But it's probably more intuitive to look at the species by names:

````julia
t3 = species(N,1)[3]
b4 = species(N,2)[4]
t3, b4
````


````
("Azteca isthmica", "Cecropia ficifolia")
````




We can access the interaction between these species:

````julia
N[t3,b4]
````



1


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
EcologicalNetwork.BipartiteQuantitativeNetwork{Int64,String}([1 0 … 0 0; 
1 1 … 0 0; … ; 0 0 … 2 0; 0 0 … 0 3], String["Azteca alfari", "Azte
ca isthmica", "Azteca aff. Isthmica", "Azteca HC", "Azteca G", "Azteca CO",
 "Azteca TO", "Azteca schummani", "Azteca D", "Azteca polymorpha", "Azteca 
Q"], String["Cecropia purpuracens", "Cecropia concolor", "Cecropia distachy
a", "Cecropia ficifolia", "Pouruma heterophylla", "Hirtella myrmecophila", 
"Hirtella physophora", "Duroia saccifera", "Cordia nodosa", "Cordia aff. No
dosa", "Tococa bullifera", "Maieta guianensis", "Maieta poeppiggi", "Tachig
ali polyphylla", "Tachigali myrmecophila", "Amaioua aff. Guianensis"])
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
Dict{String,Int64} with 41 entries:
  "Pseudomyrmex concolor"         => 2
  "Hirtella myrmecophila"         => 1
  "Azteca isthmica"               => 4
  "Cordia nodosa"                 => 1
  "Cordia aff. Nodosa"            => 7
  "Tococa bullifera"              => 6
  "Cecropia purpuracens"          => 4
  "Azteca schummani"              => 2
  "Solenops A"                    => 2
  "Pseudomyrmex nigrescens"       => 2
  "Crematogaster B"               => 3
  "Crematogaster C"               => 2
  "Azteca D"                      => 1
  "Cecropia distachya"            => 1
  "Tachigali polyphylla"          => 3
  "Maieta guianensis"             => 3
  "Allomerus aff. Octoarticulata" => 3
  "Azteca G"                      => 3
  "Amaioua aff. Guianensis"       => 1
  ⋮                               => ⋮
````




We can also look at the degree on either sides, for example the degree of
plants (*i.e.* number of insects interacting with them):

````julia
degree(N,2)
````


````
Dict{String,Int64} with 16 entries:
  "Hirtella myrmecophila"   => 1
  "Cordia nodosa"           => 1
  "Cordia aff. Nodosa"      => 7
  "Tococa bullifera"        => 6
  "Cecropia purpuracens"    => 4
  "Cecropia distachya"      => 1
  "Tachigali polyphylla"    => 3
  "Maieta guianensis"       => 3
  "Duroia saccifera"        => 4
  "Amaioua aff. Guianensis" => 1
  "Cecropia concolor"       => 1
  "Hirtella physophora"     => 4
  "Pouruma heterophylla"    => 1
  "Cecropia ficifolia"      => 2
  "Maieta poeppiggi"        => 3
  "Tachigali myrmecophila"  => 6
````



