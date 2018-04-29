---
title : Network dissimilarity
author : Timothée Poisot
date : 11th April 2018
layout: default
slug: Network dissimilarity
---




In this case study, we will compare the species composition and interaction
composition of a collection of networks:

## Getting a collection of networks

We will use data from the Morne Seychellois National Park, which are part of web
of life. Because network dissimilarity requires binary data, we will also
convert the networks on the fly.

````julia
locale = "Morne Seychellois National Park"
records = filter(x -> contains(x.Locality_of_Study, locale), web_of_life())
ids = getfield.(records, :ID)
N = convert.(BinaryNetwork, web_of_life.(ids))
````





We can have a look at the number of species / interactions in the dataset:

````julia
scatter(richness.(N), links.(N), leg=false)
````



<div id="0247d838-721b-4bea-8a5c-b78a94f24f4c" style="width:576px;height:384px;"></div>
<script>
PLOT = document.getElementById('0247d838-721b-4bea-8a5c-b78a94f24f4c');
Plotly.plot(PLOT, [{"showlegend":true,"mode":"markers","xaxis":"x1","colorbar":{"title":""},"marker":{"symbol":"circle","color":["rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)"],"line":{"color":["rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)"],"width":1},"size":8},"y":[17,27,24,29,51,58,62,35,15,20,17,24,39,18,33,41,19,35,44,25,43,28,45,46,21,28,21,36,39,30,35,28,6,9,19,31,43,49,46,58,11,16,26,23,50,45,57,32],"type":"scatter","name":"y1","yaxis":"y1","x":[17,22,20,22,34,35,32,25,16,19,18,19,26,17,24,27,22,29,32,25,29,28,36,29,16,20,19,27,26,20,24,24,8,10,22,24,30,33,30,35,13,17,25,21,34,34,35,23]}], {"showlegend":false,"paper_bgcolor":"rgba(255, 255, 255, 1.000)","xaxis1":{"showticklabels":true,"gridwidth":0.5,"tickvals":[10.0,15.0,20.0,25.0,30.0,35.0],"visible":true,"ticks":"inside","range":[7.16,36.84],"domain":[0.03769928064547487,0.9931649168853894],"tickmode":"array","linecolor":"rgba(0, 0, 0, 1.000)","showgrid":true,"title":"","mirror":false,"tickangle":0,"showline":true,"gridcolor":"rgba(0, 0, 0, 0.100)","titlefont":{"color":"rgba(0, 0, 0, 1.000)","family":"sans-serif","size":15},"tickcolor":"rgb(0, 0, 0)","ticktext":["10","15","20","25","30","35"],"zeroline":false,"type":"-","tickfont":{"color":"rgba(0, 0, 0, 1.000)","family":"sans-serif","size":11},"zerolinecolor":"rgba(0, 0, 0, 1.000)","anchor":"y1"},"annotations":[],"height":384,"margin":{"l":0,"b":20,"r":0,"t":20},"plot_bgcolor":"rgba(255, 255, 255, 1.000)","yaxis1":{"showticklabels":true,"gridwidth":0.5,"tickvals":[10.0,20.0,30.0,40.0,50.0,60.0],"visible":true,"ticks":"inside","range":[4.32,63.68],"domain":[0.0391878098571012,0.989747375328084],"tickmode":"array","linecolor":"rgba(0, 0, 0, 1.000)","showgrid":true,"title":"","mirror":false,"tickangle":0,"showline":true,"gridcolor":"rgba(0, 0, 0, 0.100)","titlefont":{"color":"rgba(0, 0, 0, 1.000)","family":"sans-serif","size":15},"tickcolor":"rgb(0, 0, 0)","ticktext":["10","20","30","40","50","60"],"zeroline":false,"type":"-","tickfont":{"color":"rgba(0, 0, 0, 1.000)","family":"sans-serif","size":11},"zerolinecolor":"rgba(0, 0, 0, 1.000)","anchor":"x1"},"width":576});
</script>




## Aggregating networks into the metaweb

The first step in the analysis is to aggregate all local networks into the
regional "metaweb". This is the same thing as adding all networks together,
which we can do with a `reduce` operation on the array of networks:

````julia
M = reduce(union, N)
println("S: ", richness(M), " - L: ", links(M))
````


````
S: 378 - L: 729
````





Having the metaweb allows us to measure how much interactions within each
network differ from what we know at the regional scale:

````julia
βos.(N, M) .|> soresen
````


<pre class="julia-error">
ERROR: UndefVarError: soresen not defined
</pre>

