---
title : Measuring species specificity
author : Timothée Poisot
layout: default
---




Ecological specificity is an important property of species within a network. One
way to approach it is to measure the degree of species. For example we can
measure the degree of ants in the ant-plant network of Fonseca & Ganade (1996):

````julia
N = web_of_life("M_PA_004")
degree(N, 1)
````


````
Dict{String,Int64} with 48 entries:
  "Dysoxylum papuanum"                 => 1
  "Cryptocarya murrayi"                => 12
  "Licuala ramsayi"                    => 7
  "Ichnocarpus frutescens"             => 9
  "Ficus septica"                      => 2
  "Syzygium cormiflorum"               => 1
  "Normanbya normanbyi"                => 5
  "Merremia peltata"                   => 25
  "Rockinghamia angustifolia"          => 8
  "Glochidion philippicum"             => 5
  "Dysoxylum mollissimum subsp. molle" => 1
  "Archontophoenix alexandrae"         => 3
  "Syzygium sayeri"                    => 3
  "Elaeocarpus angustifolius"          => 4
  "Urena lobata"                       => 1
  "Macaranga tanarius"                 => 3
  "Homalanthus novoguineensis"         => 22
  "Neosepicaea jucunda"                => 1
  "Stephania japonica"                 => 1
  ⋮                                    => ⋮
````





A useful way to see represent this information is to plot the sorted degrees:

````julia
degree(N,1) |>
  values |> collect |>
  sort |> reverse |>
  x -> scatter(x, ylab="Species degree", xlab="Species rank", lab="")
````



<div id="24f033fe-ee98-4b94-97b7-ca7c05dc03ed" style="width:576px;height:384px;"></div>
<script>
PLOT = document.getElementById('24f033fe-ee98-4b94-97b7-ca7c05dc03ed');
Plotly.plot(PLOT, [{"showlegend":false,"mode":"markers","xaxis":"x1","colorbar":{"title":""},"marker":{"symbol":"circle","color":["rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)"],"line":{"color":["rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)"],"width":1},"size":8},"y":[25,24,22,22,15,14,13,12,11,9,8,8,8,7,7,5,5,5,5,4,4,4,3,3,3,3,3,3,3,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1,1,1],"type":"scatter","name":"","yaxis":"y1","x":[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48]}], {"showlegend":true,"paper_bgcolor":"rgba(255, 255, 255, 1.000)","xaxis1":{"showticklabels":true,"gridwidth":0.5,"tickvals":[0.0,10.0,20.0,30.0,40.0],"visible":true,"ticks":"inside","range":[-0.4099999999999999,49.41],"domain":[0.06422320039856129,0.9931649168853893],"tickmode":"array","linecolor":"rgba(0, 0, 0, 1.000)","showgrid":true,"title":"Species rank","mirror":false,"tickangle":0,"showline":true,"gridcolor":"rgba(0, 0, 0, 0.100)","titlefont":{"color":"rgba(0, 0, 0, 1.000)","family":"sans-serif","size":15},"tickcolor":"rgb(0, 0, 0)","ticktext":["0","10","20","30","40"],"zeroline":false,"type":"-","tickfont":{"color":"rgba(0, 0, 0, 1.000)","family":"sans-serif","size":11},"zerolinecolor":"rgba(0, 0, 0, 1.000)","anchor":"y1"},"annotations":[],"height":384,"margin":{"l":0,"b":20,"r":0,"t":20},"plot_bgcolor":"rgba(255, 255, 255, 1.000)","yaxis1":{"showticklabels":true,"gridwidth":0.5,"tickvals":[5.0,10.0,15.0,20.0,25.0],"visible":true,"ticks":"inside","range":[0.28,25.72],"domain":[0.07897368948673088,0.989747375328084],"tickmode":"array","linecolor":"rgba(0, 0, 0, 1.000)","showgrid":true,"title":"Species degree","mirror":false,"tickangle":0,"showline":true,"gridcolor":"rgba(0, 0, 0, 0.100)","titlefont":{"color":"rgba(0, 0, 0, 1.000)","family":"sans-serif","size":15},"tickcolor":"rgb(0, 0, 0)","ticktext":["5","10","15","20","25"],"zeroline":false,"type":"-","tickfont":{"color":"rgba(0, 0, 0, 1.000)","family":"sans-serif","size":11},"zerolinecolor":"rgba(0, 0, 0, 1.000)","anchor":"x1"},"legend":{"bordercolor":"rgba(0, 0, 0, 1.000)","bgcolor":"rgba(255, 255, 255, 1.000)","font":{"color":"rgba(0, 0, 0, 1.000)","family":"sans-serif","size":11},"y":1.0,"x":1.0},"width":576});
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
  values |> collect |>
  sort |> reverse |>
  x -> scatter(x, ylab="Resource range", xlab="Species rank", lab="")
````



<div id="03dd2903-6a3d-458a-b2bc-7c8ded5999da" style="width:576px;height:384px;"></div>
<script>
PLOT = document.getElementById('03dd2903-6a3d-458a-b2bc-7c8ded5999da');
Plotly.plot(PLOT, [{"showlegend":false,"mode":"markers","xaxis":"x1","colorbar":{"title":""},"marker":{"symbol":"circle","color":["rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)"],"line":{"color":["rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)"],"width":1},"size":8},"y":[1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,0.975,0.975,0.975,0.975,0.975,0.975,0.975,0.95,0.95,0.95,0.95,0.95,0.95,0.95,0.925,0.925,0.925,0.9,0.9,0.9,0.9,0.85,0.85,0.825,0.825,0.825,0.8,0.75,0.725,0.7,0.675,0.65,0.475,0.475,0.425,0.4],"type":"scatter","name":"","yaxis":"y1","x":[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48]}], {"showlegend":true,"paper_bgcolor":"rgba(255, 255, 255, 1.000)","xaxis1":{"showticklabels":true,"gridwidth":0.5,"tickvals":[0.0,10.0,20.0,30.0,40.0],"visible":true,"ticks":"inside","range":[-0.4099999999999999,49.41],"domain":[0.07965529916399339,0.9931649168853892],"tickmode":"array","linecolor":"rgba(0, 0, 0, 1.000)","showgrid":true,"title":"Species rank","mirror":false,"tickangle":0,"showline":true,"gridcolor":"rgba(0, 0, 0, 0.100)","titlefont":{"color":"rgba(0, 0, 0, 1.000)","family":"sans-serif","size":15},"tickcolor":"rgb(0, 0, 0)","ticktext":["0","10","20","30","40"],"zeroline":false,"type":"-","tickfont":{"color":"rgba(0, 0, 0, 1.000)","family":"sans-serif","size":11},"zerolinecolor":"rgba(0, 0, 0, 1.000)","anchor":"y1"},"annotations":[],"height":384,"margin":{"l":0,"b":20,"r":0,"t":20},"plot_bgcolor":"rgba(255, 255, 255, 1.000)","yaxis1":{"showticklabels":true,"gridwidth":0.5,"tickvals":[0.4,0.5,0.6000000000000001,0.7000000000000001,0.8,0.9,1.0],"visible":true,"ticks":"inside","range":[0.382,1.018],"domain":[0.07897368948673088,0.989747375328084],"tickmode":"array","linecolor":"rgba(0, 0, 0, 1.000)","showgrid":true,"title":"Resource range","mirror":false,"tickangle":0,"showline":true,"gridcolor":"rgba(0, 0, 0, 0.100)","titlefont":{"color":"rgba(0, 0, 0, 1.000)","family":"sans-serif","size":15},"tickcolor":"rgb(0, 0, 0)","ticktext":["0.4","0.5","0.6","0.7","0.8","0.9","1.0"],"zeroline":false,"type":"-","tickfont":{"color":"rgba(0, 0, 0, 1.000)","family":"sans-serif","size":11},"zerolinecolor":"rgba(0, 0, 0, 1.000)","anchor":"x1"},"legend":{"bordercolor":"rgba(0, 0, 0, 1.000)","bgcolor":"rgba(255, 255, 255, 1.000)","font":{"color":"rgba(0, 0, 0, 1.000)","family":"sans-serif","size":11},"y":1.0,"x":1.0},"width":576});
</script>




Interesting! Even though some species have up to 
25 interactions, because there are 
41
plants available, the specificity of all ants is high.

We can also look at the specificity accounting for interaction strength -- this
defaults to using the *Paired-differences index*, which similarly returns 1 when
the species is a specialist.

````julia
N |>
  specificity |>
  values |> collect |>
  sort |> reverse |>
  x -> scatter(x, ylab="Paired-differences index", xlab="Species rank", lab="")
````



<div id="abdb6eb8-610b-4fd3-b9d6-f9f63cb8dcfb" style="width:576px;height:384px;"></div>
<script>
PLOT = document.getElementById('abdb6eb8-610b-4fd3-b9d6-f9f63cb8dcfb');
Plotly.plot(PLOT, [{"showlegend":false,"mode":"markers","xaxis":"x1","colorbar":{"title":""},"marker":{"symbol":"circle","color":["rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)"],"line":{"color":["rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)"],"width":1},"size":8},"y":[1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,0.9949999999999999,0.9916666666666668,0.9875,0.9875,0.975,0.975,0.975,0.975,0.965625,0.9625,0.9625,0.9625,0.9541666666666668,0.95,0.95,0.95,0.95,0.95,0.95,0.95,0.95,0.95,0.9400000000000001,0.9375,0.925,0.9178571428571427,0.9125,0.9114583333333334,0.9083333333333334,0.9,0.89375,0.8875,0.8875,0.8823529411764705,0.8375,0.8111111111111111],"type":"scatter","name":"","yaxis":"y1","x":[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48]}], {"showlegend":true,"paper_bgcolor":"rgba(255, 255, 255, 1.000)","xaxis1":{"showticklabels":true,"gridwidth":0.5,"tickvals":[0.0,10.0,20.0,30.0,40.0],"visible":true,"ticks":"inside","range":[-0.4099999999999999,49.41],"domain":[0.09508739792942547,0.9931649168853893],"tickmode":"array","linecolor":"rgba(0, 0, 0, 1.000)","showgrid":true,"title":"Species rank","mirror":false,"tickangle":0,"showline":true,"gridcolor":"rgba(0, 0, 0, 0.100)","titlefont":{"color":"rgba(0, 0, 0, 1.000)","family":"sans-serif","size":15},"tickcolor":"rgb(0, 0, 0)","ticktext":["0","10","20","30","40"],"zeroline":false,"type":"-","tickfont":{"color":"rgba(0, 0, 0, 1.000)","family":"sans-serif","size":11},"zerolinecolor":"rgba(0, 0, 0, 1.000)","anchor":"y1"},"annotations":[],"height":384,"margin":{"l":0,"b":20,"r":0,"t":20},"plot_bgcolor":"rgba(255, 255, 255, 1.000)","yaxis1":{"showticklabels":true,"gridwidth":0.5,"tickvals":[0.8500000000000001,0.9,0.9500000000000001,1.0],"visible":true,"ticks":"inside","range":[0.8054444444444444,1.0056666666666667],"domain":[0.07897368948673088,0.989747375328084],"tickmode":"array","linecolor":"rgba(0, 0, 0, 1.000)","showgrid":true,"title":"Paired-differences index","mirror":false,"tickangle":0,"showline":true,"gridcolor":"rgba(0, 0, 0, 0.100)","titlefont":{"color":"rgba(0, 0, 0, 1.000)","family":"sans-serif","size":15},"tickcolor":"rgb(0, 0, 0)","ticktext":["0.85","0.90","0.95","1.00"],"zeroline":false,"type":"-","tickfont":{"color":"rgba(0, 0, 0, 1.000)","family":"sans-serif","size":11},"zerolinecolor":"rgba(0, 0, 0, 1.000)","anchor":"x1"},"legend":{"bordercolor":"rgba(0, 0, 0, 1.000)","bgcolor":"rgba(255, 255, 255, 1.000)","font":{"color":"rgba(0, 0, 0, 1.000)","family":"sans-serif","size":11},"y":1.0,"x":1.0},"width":576});
</script>

