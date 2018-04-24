---
title : Datasets
author : Timothée Poisot
date : 11th April 2018
layout: default
---




# Bipartite networks

## TODO

````julia
fonseca_ganade_1996()
````


````
EcologicalNetwork.BipartiteQuantitativeNetwork{Int64,String}([11 0 … 0 0;
 1 0 … 0 0; … ; 0 0 … 1 0; 0 0 … 0 3], String["Camponotus balzanii"
, "Azteca alfari", "Azteca isthmica", "Azteca aff. Isthmica", "Allomerus D"
, "Allomerus prancei", "Allomerus aff. Octoarticulata", "Solenops A", "Allo
merus auripunctata", "Crematogaster B"  …  "Crematogaster A", "Azteca TO"
, "Crematogaster C", "Azteca schummani", "Pseudomyrmex nigrescens", "Pseudo
myrmex concolor", "Azteca D", "Azteca polymorpha", "Crematogaster E", "Azte
ca Q"], String["Cecropia purpuracens", "Cecropia concolor", "Cecropia dista
chya", "Cecropia ficifolia", "Pouruma heterophylla", "Hirtella myrmecophila
", "Hirtella physophora", "Duroia saccifera", "Cordia nodosa", "Cordia aff.
 Nodosa", "Tococa bullifera", "Maieta guianensis", "Maieta poeppiggi", "Tac
higali polyphylla", "Tachigali myrmecophila", "Amaioua aff. Guianensis"])
````





## Plant-pollinators on the Canaria islands

**TODO**

The networks are returned as an array, with each position corresponding to the
site number in the original study.

````julia
Tr = trojelsgaard_et_al_2014()
richness.(Tr)
````


````
14-element Array{Int64,1}:
 63
 54
 46
 46
 45
 45
 53
 67
 48
 63
 44
 52
 41
 47
````





# Unipartite networks

````julia
TTC = thompson_townsend_catlins()
println("Richness: $(richness(TTC))\tConnectance: $(connectance(TTC))")
````


````
Richness: 49	Connectance: 0.04581424406497293
````


