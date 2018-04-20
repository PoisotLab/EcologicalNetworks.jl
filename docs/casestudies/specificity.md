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



<div id="1551b8be-86d4-4018-8bf9-5dfc5580522e" style="width:576px;height:384px;"></div>
<script>
PLOT = document.getElementById('1551b8be-86d4-4018-8bf9-5dfc5580522e');
Plotly.plot(PLOT, [{"showlegend":false,"mode":"markers","xaxis":"x1","colorbar":{"title":""},"marker":{"symbol":"circle","color":["rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)"],"line":{"color":["rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)"],"width":1},"size":8},"y":[4,4,3,3,3,3,2,2,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1],"type":"scatter","name":"","yaxis":"y1","x":[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25]}], {"showlegend":true,"paper_bgcolor":"rgba(255, 255, 255, 1.000)","xaxis1":{"showticklabels":true,"gridwidth":0.5,"tickvals":[5.0,10.0,15.0,20.0,25.0],"visible":true,"ticks":"inside","range":[0.28,25.72],"domain":[0.048791101633129184,0.9931649168853893],"tickmode":"array","linecolor":"rgba(0, 0, 0, 1.000)","showgrid":true,"title":"Species rank","mirror":false,"tickangle":0,"showline":true,"gridcolor":"rgba(0, 0, 0, 0.100)","titlefont":{"color":"rgba(0, 0, 0, 1.000)","family":"sans-serif","size":15},"tickcolor":"rgb(0, 0, 0)","ticktext":["5","10","15","20","25"],"zeroline":false,"type":"-","tickfont":{"color":"rgba(0, 0, 0, 1.000)","family":"sans-serif","size":11},"zerolinecolor":"rgba(0, 0, 0, 1.000)","anchor":"y1"},"annotations":[],"height":384,"margin":{"l":0,"b":20,"r":0,"t":20},"plot_bgcolor":"rgba(255, 255, 255, 1.000)","yaxis1":{"showticklabels":true,"gridwidth":0.5,"tickvals":[1.0,2.0,3.0,4.0],"visible":true,"ticks":"inside","range":[0.91,4.09],"domain":[0.07897368948673088,0.989747375328084],"tickmode":"array","linecolor":"rgba(0, 0, 0, 1.000)","showgrid":true,"title":"Species degree","mirror":false,"tickangle":0,"showline":true,"gridcolor":"rgba(0, 0, 0, 0.100)","titlefont":{"color":"rgba(0, 0, 0, 1.000)","family":"sans-serif","size":15},"tickcolor":"rgb(0, 0, 0)","ticktext":["1","2","3","4"],"zeroline":false,"type":"-","tickfont":{"color":"rgba(0, 0, 0, 1.000)","family":"sans-serif","size":11},"zerolinecolor":"rgba(0, 0, 0, 1.000)","anchor":"x1"},"legend":{"bordercolor":"rgba(0, 0, 0, 1.000)","bgcolor":"rgba(255, 255, 255, 1.000)","font":{"color":"rgba(0, 0, 0, 1.000)","family":"sans-serif","size":11},"y":1.0,"x":1.0},"width":576});
</script>




This is an easy way to see that there are comparatively fewer species with many
interactions, and more species with a single interaction.

Species degree is not really scaled -- it can vary between 0 and 1. For this
reason, we will look at measures of specificity instead.

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



<div id="b19b8537-f3b8-48bc-bb5f-48b35ff7d027" style="width:576px;height:384px;"></div>
<script>
PLOT = document.getElementById('b19b8537-f3b8-48bc-bb5f-48b35ff7d027');
Plotly.plot(PLOT, [{"showlegend":false,"mode":"markers","xaxis":"x1","colorbar":{"title":""},"marker":{"symbol":"circle","color":["rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)"],"line":{"color":["rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)"],"width":1},"size":8},"y":[1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,0.9333333333333333,0.9333333333333333,0.9333333333333333,0.9333333333333333,0.9333333333333333,0.9333333333333333,0.9333333333333333,0.9333333333333333,0.9333333333333333,0.8666666666666667,0.8666666666666667,0.8666666666666667,0.8666666666666667,0.8,0.8],"type":"scatter","name":"","yaxis":"y1","x":[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25]}], {"showlegend":true,"paper_bgcolor":"rgba(255, 255, 255, 1.000)","xaxis1":{"showticklabels":true,"gridwidth":0.5,"tickvals":[5.0,10.0,15.0,20.0,25.0],"visible":true,"ticks":"inside","range":[0.28,25.72],"domain":[0.09508739792942547,0.9931649168853893],"tickmode":"array","linecolor":"rgba(0, 0, 0, 1.000)","showgrid":true,"title":"Species rank","mirror":false,"tickangle":0,"showline":true,"gridcolor":"rgba(0, 0, 0, 0.100)","titlefont":{"color":"rgba(0, 0, 0, 1.000)","family":"sans-serif","size":15},"tickcolor":"rgb(0, 0, 0)","ticktext":["5","10","15","20","25"],"zeroline":false,"type":"-","tickfont":{"color":"rgba(0, 0, 0, 1.000)","family":"sans-serif","size":11},"zerolinecolor":"rgba(0, 0, 0, 1.000)","anchor":"y1"},"annotations":[],"height":384,"margin":{"l":0,"b":20,"r":0,"t":20},"plot_bgcolor":"rgba(255, 255, 255, 1.000)","yaxis1":{"showticklabels":true,"gridwidth":0.5,"tickvals":[0.8,0.8500000000000001,0.9,0.9500000000000001,1.0],"visible":true,"ticks":"inside","range":[0.794,1.006],"domain":[0.07897368948673088,0.989747375328084],"tickmode":"array","linecolor":"rgba(0, 0, 0, 1.000)","showgrid":true,"title":"Resource range","mirror":false,"tickangle":0,"showline":true,"gridcolor":"rgba(0, 0, 0, 0.100)","titlefont":{"color":"rgba(0, 0, 0, 1.000)","family":"sans-serif","size":15},"tickcolor":"rgb(0, 0, 0)","ticktext":["0.80","0.85","0.90","0.95","1.00"],"zeroline":false,"type":"-","tickfont":{"color":"rgba(0, 0, 0, 1.000)","family":"sans-serif","size":11},"zerolinecolor":"rgba(0, 0, 0, 1.000)","anchor":"x1"},"legend":{"bordercolor":"rgba(0, 0, 0, 1.000)","bgcolor":"rgba(255, 255, 255, 1.000)","font":{"color":"rgba(0, 0, 0, 1.000)","family":"sans-serif","size":11},"y":1.0,"x":1.0},"width":576});
</script>




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



<div id="ca83308b-0b6c-4623-88c0-89b5c65219af" style="width:576px;height:384px;"></div>
<script>
PLOT = document.getElementById('ca83308b-0b6c-4623-88c0-89b5c65219af');
Plotly.plot(PLOT, [{"showlegend":false,"mode":"markers","xaxis":"x1","colorbar":{"title":""},"marker":{"symbol":"circle","color":["rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)"],"line":{"color":["rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)"],"width":1},"size":8},"y":[1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,0.9792114695340501,0.9777777777777779,0.9714285714285714,0.9708333333333333,0.9666666666666667,0.9666666666666667,0.9638888888888889,0.9555555555555556,0.9407407407407408,0.9333333333333333,0.9333333333333333,0.9333333333333333,0.9142857142857144,0.8666666666666667,0.8],"type":"scatter","name":"","yaxis":"y1","x":[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25]}], {"showlegend":true,"paper_bgcolor":"rgba(255, 255, 255, 1.000)","xaxis1":{"showticklabels":true,"gridwidth":0.5,"tickvals":[5.0,10.0,15.0,20.0,25.0],"visible":true,"ticks":"inside","range":[0.28,25.72],"domain":[0.09508739792942547,0.9931649168853893],"tickmode":"array","linecolor":"rgba(0, 0, 0, 1.000)","showgrid":true,"title":"Species rank","mirror":false,"tickangle":0,"showline":true,"gridcolor":"rgba(0, 0, 0, 0.100)","titlefont":{"color":"rgba(0, 0, 0, 1.000)","family":"sans-serif","size":15},"tickcolor":"rgb(0, 0, 0)","ticktext":["5","10","15","20","25"],"zeroline":false,"type":"-","tickfont":{"color":"rgba(0, 0, 0, 1.000)","family":"sans-serif","size":11},"zerolinecolor":"rgba(0, 0, 0, 1.000)","anchor":"y1"},"annotations":[],"height":384,"margin":{"l":0,"b":20,"r":0,"t":20},"plot_bgcolor":"rgba(255, 255, 255, 1.000)","yaxis1":{"showticklabels":true,"gridwidth":0.5,"tickvals":[0.8,0.8500000000000001,0.9,0.9500000000000001,1.0],"visible":true,"ticks":"inside","range":[0.794,1.006],"domain":[0.07897368948673088,0.989747375328084],"tickmode":"array","linecolor":"rgba(0, 0, 0, 1.000)","showgrid":true,"title":"Paired-differences index","mirror":false,"tickangle":0,"showline":true,"gridcolor":"rgba(0, 0, 0, 0.100)","titlefont":{"color":"rgba(0, 0, 0, 1.000)","family":"sans-serif","size":15},"tickcolor":"rgb(0, 0, 0)","ticktext":["0.80","0.85","0.90","0.95","1.00"],"zeroline":false,"type":"-","tickfont":{"color":"rgba(0, 0, 0, 1.000)","family":"sans-serif","size":11},"zerolinecolor":"rgba(0, 0, 0, 1.000)","anchor":"x1"},"legend":{"bordercolor":"rgba(0, 0, 0, 1.000)","bgcolor":"rgba(255, 255, 255, 1.000)","font":{"color":"rgba(0, 0, 0, 1.000)","family":"sans-serif","size":11},"y":1.0,"x":1.0},"width":576});
</script>




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
