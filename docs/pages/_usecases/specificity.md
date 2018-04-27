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
degree(N,1) |>
  values |> collect |>
  sort |> reverse |>
  x -> scatter(x, ylab="Species degree", xlab="Species rank", lab="")
````



<div id="0f80f07d-e282-4ffd-8f2f-babe43fea004" style="width:576px;height:384px;"></div>
<script>
PLOT = document.getElementById('0f80f07d-e282-4ffd-8f2f-babe43fea004');
Plotly.plot(PLOT, [{"showlegend":false,"mode":"markers","xaxis":"x1","colorbar":{"title":""},"marker":{"symbol":"circle","color":["rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)"],"line":{"color":["rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)"],"width":1},"size":8},"y":[4,4,3,3,3,3,2,2,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1],"type":"scatter","name":"","yaxis":"y1","x":[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25]}], {"showlegend":true,"paper_bgcolor":"rgba(255, 255, 255, 1.000)","xaxis1":{"showticklabels":true,"gridwidth":0.5,"tickvals":[5.0,10.0,15.0,20.0,25.0],"visible":true,"ticks":"inside","range":[0.28,25.72],"domain":[0.048791101633129184,0.9931649168853893],"tickmode":"array","linecolor":"rgba(0, 0, 0, 1.000)","showgrid":true,"title":"Species rank","mirror":false,"tickangle":0,"showline":true,"gridcolor":"rgba(0, 0, 0, 0.100)","titlefont":{"color":"rgba(0, 0, 0, 1.000)","family":"sans-serif","size":15},"tickcolor":"rgb(0, 0, 0)","ticktext":["5","10","15","20","25"],"zeroline":false,"type":"-","tickfont":{"color":"rgba(0, 0, 0, 1.000)","family":"sans-serif","size":11},"zerolinecolor":"rgba(0, 0, 0, 1.000)","anchor":"y1"},"annotations":[],"height":384,"margin":{"l":0,"b":20,"r":0,"t":20},"plot_bgcolor":"rgba(255, 255, 255, 1.000)","yaxis1":{"showticklabels":true,"gridwidth":0.5,"tickvals":[1.0,2.0,3.0,4.0],"visible":true,"ticks":"inside","range":[0.91,4.09],"domain":[0.07897368948673088,0.989747375328084],"tickmode":"array","linecolor":"rgba(0, 0, 0, 1.000)","showgrid":true,"title":"Species degree","mirror":false,"tickangle":0,"showline":true,"gridcolor":"rgba(0, 0, 0, 0.100)","titlefont":{"color":"rgba(0, 0, 0, 1.000)","family":"sans-serif","size":15},"tickcolor":"rgb(0, 0, 0)","ticktext":["1","2","3","4"],"zeroline":false,"type":"-","tickfont":{"color":"rgba(0, 0, 0, 1.000)","family":"sans-serif","size":11},"zerolinecolor":"rgba(0, 0, 0, 1.000)","anchor":"x1"},"legend":{"bordercolor":"rgba(0, 0, 0, 1.000)","bgcolor":"rgba(255, 255, 255, 1.000)","font":{"color":"rgba(0, 0, 0, 1.000)","family":"sans-serif","size":11},"y":1.0,"x":1.0},"width":576});
</script>




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
ERROR: MethodError: no method matching reverse&#40;::DataStructures.OrderedDict&#123;String,Float64&#125;&#41;
Closest candidates are:
  reverse&#40;&#33;Matched::String&#41; at strings/string.jl:395
  reverse&#40;&#33;Matched::BitArray&#123;1&#125;&#41; at bitarray.jl:1364
  reverse&#40;&#33;Matched::Tuple&#41; at tuple.jl:317
  ...
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
ERROR: MethodError: no method matching reverse&#40;::DataStructures.OrderedDict&#123;String,Float64&#125;&#41;
Closest candidates are:
  reverse&#40;&#33;Matched::String&#41; at strings/string.jl:395
  reverse&#40;&#33;Matched::BitArray&#123;1&#125;&#41; at bitarray.jl:1364
  reverse&#40;&#33;Matched::Tuple&#41; at tuple.jl:317
  ...
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
````


<pre class="julia-error">
ERROR: MethodError: no method matching -&#40;::Dict&#123;String,Float64&#125;, ::Dict&#123;String,Float64&#125;&#41;
Closest candidates are:
  -&#40;&#33;Matched::DataValues.DataValue&#123;T1&#125;, ::T2&#41; where &#123;T1, T2&#125; at /home/tpoisot/.julia/v0.6/DataValues/src/scalar/operations.jl:55
  -&#40;::T1, &#33;Matched::DataValues.DataValue&#123;T2&#125;&#41; where &#123;T1, T2&#125; at /home/tpoisot/.julia/v0.6/DataValues/src/scalar/operations.jl:65
</pre>


````julia
sort(collect(spe), by=x->x[2])
````


<pre class="julia-error">
ERROR: UndefVarError: spe not defined
</pre>




Species with the highest values of this difference are increasingly specialized
compared to their number of interactions.
