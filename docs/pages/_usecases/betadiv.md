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



<div id="4d5208a9-d2b5-491c-a6b8-a85c482e59f7" style="width:576px;height:384px;"></div>
<script>
PLOT = document.getElementById('4d5208a9-d2b5-491c-a6b8-a85c482e59f7');
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
os_prime = βos.(N, M) .|> sorensen
histogram(os_prime, xlims=(0.0,1.0))
````



<div id="bf56f331-718a-445a-acff-5b505e418746" style="width:576px;height:384px;"></div>
<script>
PLOT = document.getElementById('bf56f331-718a-445a-acff-5b505e418746');
Plotly.plot(PLOT, [{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.55,0.55,0.5999999999999999,0.5999999999999999,0.55,0.55],"showlegend":true,"mode":"lines","fillcolor":"rgba(0, 154, 250, 1.000)","name":"y1","line":{"color":"rgba(0, 0, 0, 1.000)","dash":"solid","width":1},"y":[2.0,0.0,0.0,2.0,2.0,2.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.6,0.6,0.65,0.65,0.6,0.6],"showlegend":false,"mode":"lines","fillcolor":"rgba(0, 154, 250, 1.000)","name":"y1","line":{"color":"rgba(0, 0, 0, 1.000)","dash":"solid","width":1},"y":[2.0,0.0,0.0,2.0,2.0,2.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.6500000000000001,0.6500000000000001,0.7,0.7,0.6500000000000001,0.6500000000000001],"showlegend":false,"mode":"lines","fillcolor":"rgba(0, 154, 250, 1.000)","name":"y1","line":{"color":"rgba(0, 0, 0, 1.000)","dash":"solid","width":1},"y":[9.0,0.0,0.0,9.0,9.0,9.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.7,0.7,0.75,0.75,0.7,0.7],"showlegend":false,"mode":"lines","fillcolor":"rgba(0, 154, 250, 1.000)","name":"y1","line":{"color":"rgba(0, 0, 0, 1.000)","dash":"solid","width":1},"y":[14.0,0.0,0.0,14.0,14.0,14.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.75,0.75,0.8,0.8,0.75,0.75],"showlegend":false,"mode":"lines","fillcolor":"rgba(0, 154, 250, 1.000)","name":"y1","line":{"color":"rgba(0, 0, 0, 1.000)","dash":"solid","width":1},"y":[10.0,0.0,0.0,10.0,10.0,10.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.8,0.8,0.8499999999999999,0.8499999999999999,0.8,0.8],"showlegend":false,"mode":"lines","fillcolor":"rgba(0, 154, 250, 1.000)","name":"y1","line":{"color":"rgba(0, 0, 0, 1.000)","dash":"solid","width":1},"y":[9.0,0.0,0.0,9.0,9.0,9.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.85,0.85,0.9,0.9,0.85,0.85],"showlegend":false,"mode":"lines","fillcolor":"rgba(0, 154, 250, 1.000)","name":"y1","line":{"color":"rgba(0, 0, 0, 1.000)","dash":"solid","width":1},"y":[2.0,0.0,0.0,2.0,2.0,2.0],"type":"scatter"}], {"showlegend":true,"paper_bgcolor":"rgba(255, 255, 255, 1.000)","xaxis1":{"showticklabels":true,"gridwidth":0.5,"tickvals":[0.0,0.2,0.4,0.6000000000000001,0.8,1.0],"visible":true,"ticks":"inside","range":[0.0,1.0],"domain":[0.03769928064547487,0.9931649168853894],"tickmode":"array","linecolor":"rgba(0, 0, 0, 1.000)","showgrid":true,"title":"","mirror":false,"tickangle":0,"showline":true,"gridcolor":"rgba(0, 0, 0, 0.100)","titlefont":{"color":"rgba(0, 0, 0, 1.000)","family":"sans-serif","size":15},"tickcolor":"rgb(0, 0, 0)","ticktext":["0.0","0.2","0.4","0.6","0.8","1.0"],"zeroline":false,"type":"-","tickfont":{"color":"rgba(0, 0, 0, 1.000)","family":"sans-serif","size":11},"zerolinecolor":"rgba(0, 0, 0, 1.000)","anchor":"y1"},"annotations":[],"height":384,"margin":{"l":0,"b":20,"r":0,"t":20},"plot_bgcolor":"rgba(255, 255, 255, 1.000)","yaxis1":{"showticklabels":true,"gridwidth":0.5,"tickvals":[0.0,2.0,4.0,6.0,8.0,10.0,12.0,14.0],"visible":true,"ticks":"inside","range":[0.0,14.0],"domain":[0.0391878098571012,0.989747375328084],"tickmode":"array","linecolor":"rgba(0, 0, 0, 1.000)","showgrid":true,"title":"","mirror":false,"tickangle":0,"showline":true,"gridcolor":"rgba(0, 0, 0, 0.100)","titlefont":{"color":"rgba(0, 0, 0, 1.000)","family":"sans-serif","size":15},"tickcolor":"rgb(0, 0, 0)","ticktext":["0","2","4","6","8","10","12","14"],"zeroline":false,"type":"-","tickfont":{"color":"rgba(0, 0, 0, 1.000)","family":"sans-serif","size":11},"zerolinecolor":"rgba(0, 0, 0, 1.000)","anchor":"x1"},"legend":{"bordercolor":"rgba(0, 0, 0, 1.000)","bgcolor":"rgba(255, 255, 255, 1.000)","font":{"color":"rgba(0, 0, 0, 1.000)","family":"sans-serif","size":11},"y":1.0,"x":1.0},"width":576});
</script>




Values close to `1` indicate that the network is very dissimilar from what we
expect at the regional scale -- this can indicate strong sorting of interactions
locally.

## Measuring pairwise differences

````julia
Ds = [βs(N[i], N[j]) for i in eachindex(N), j in eachindex(N)]
Di = [βos(N[i], N[j]) for i in eachindex(N), j in eachindex(N)]
Dn = [βwn(N[i], N[j]) for i in eachindex(N), j in eachindex(N)]
bs = sorensen.(vec(Ds))
bi = sorensen.(vec(Di))
````


