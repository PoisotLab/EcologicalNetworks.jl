---
title : Measuring species specificity
author : Timothée Poisot
layout: default
---





Ecological specificity is an important property of species within a network. One
way to approach it is to measure the degree of species. For example we can
measure the degree of ants in the ant-plant network of Fonseca & Ganade (1996):

````julia
N = fonseca_ganade_1996()
degree(N, 1)
````


````
Dict{String,Int64} with 25 entries:
  "Pseudomyrmex concolor"         => 2
  "Azteca isthmica"               => 4
  "Azteca schummani"              => 2
  "Solenops A"                    => 2
  "Pseudomyrmex nigrescens"       => 2
  "Crematogaster B"               => 3
  "Crematogaster C"               => 2
  "Azteca D"                      => 1
  "Allomerus aff. Octoarticulata" => 3
  "Azteca G"                      => 3
  "Azteca TO"                     => 1
  "Crematogaster D"               => 2
  "Pheidole minutula"             => 3
  "Azteca polymorpha"             => 1
  "Camponotus balzanii"           => 1
  "Allomerus D"                   => 1
  "Crematogaster A"               => 4
  "Azteca Q"                      => 1
  "Azteca HC"                     => 1
  ⋮                               => ⋮
````





A useful way to see represent this information is to plot the sorted degrees:

````julia
degree(N,1) |> values |> collect |> sort |> reverse |> x -> scatter(x, ylab="Species degree", xlab="Species rank", lab="")
````


<pre class="julia-error">
ERROR: UndefVarError: scatter not defined
</pre>




This is an easy way to see that there are comparatively fewer species with many
interactions, and more species with a single interaction.

Species degree is not really scaled -- it can vary between 0 and 1. For this
reason, we will look at measures of specificity instead. `EcologicalNetwork`
follows the guidelines of @PoiCan12, and 

An analog to degree is the *resource range*, which returns 0 when a species
interacts will all possible partners, and 1 when it has a single partner.
Because this amounts to measuring specificity in the absence of information on
interaction strength, this is exactly what we will do:

````julia
N |>
  n -> convert(BinaryNetwork, n) |>
  specificity |>
  sort |> reverse |>
  x -> scatter(x, ylab="Resource range", xlab="Species rank", lab="")
````


<pre class="julia-error">
ERROR: UndefVarError: scatter not defined
</pre>




Interesting! Even though some species have up to 
4 interactions, because there are 
16
plants available, the specificity of all ants is high.

We can also look at the specificity accounting for interaction strength -- this
defaults to using the *Paired-differences index*, which similarly returns 1 when
the species is a specialist.

````julia
N |>
  specificity |>
  sort |> reverse |>
  x -> scatter(x, ylab="Paired-differences index", xlab="Species rank", lab="")
````


<pre class="julia-error">
ERROR: UndefVarError: scatter not defined
</pre>




Because the value of the paired differences index is strongly contingent upon
the number of interactions, it is almost always interesting to comapre the two.
Specifically, because it is possible to show that the resource range is always
lower or equal to the paired diffences index, we can safely substract them to
look at the "residuals" of specificity due to the uneven strength of
interactions:

````julia
rr = specificity(convert(BinaryNetwork,N))
pdi = specificity(N)
spe = Dict(zip(species(N,1),pdi-rr))
sort(collect(spe), by=x->x[2])
````


````
25-element Array{Pair{String,Float64},1}:
 "Azteca isthmica"=>0.0                   
 "Crematogaster B"=>0.0                   
 "Crematogaster C"=>0.0                   
 "Azteca D"=>0.0                          
 "Azteca TO"=>0.0                         
 "Azteca polymorpha"=>0.0                 
 "Camponotus balzanii"=>0.0               
 "Allomerus D"=>0.0                       
 "Azteca Q"=>0.0                          
 "Azteca HC"=>0.0                         
 ⋮                                        
 "Crematogaster D"=>0.0222222             
 "Azteca schummani"=>0.0333333            
 "Azteca aff. Isthmica"=>0.0333333        
 "Pseudomyrmex nigrescens"=>0.0375        
 "Solenops A"=>0.0444444                  
 "Azteca G"=>0.0972222                    
 "Allomerus aff. Octoarticulata"=>0.104762
 "Pheidole minutula"=>0.112545            
 "Crematogaster A"=>0.114286
````





Species with the highest values of this difference are increasingly specialized
compared to their number of interactions.
