---
title : Motif counting in food webs
author : Timothée Poisot
date : 11th April 2018
layout: default
---




In this use case, we will enumerate unipartite motifs in 
18 food webs.

````julia
NZ = nz_stream_foodweb();
````



````julia
scatter(rand(10))
````



<div id="deb2a600-a434-4184-8b9c-490305be8596" style="width:576px;height:384px;"></div>
<script>
PLOT = document.getElementById('deb2a600-a434-4184-8b9c-490305be8596');
Plotly.plot(PLOT, [{"showlegend":true,"mode":"markers","xaxis":"x1","colorbar":{"title":""},"marker":{"symbol":"circle","color":["rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)","rgba(0, 154, 250, 1.000)"],"line":{"color":["rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)","rgba(0, 0, 0, 1.000)"],"width":1},"size":8},"y":[0.9274205819103605,0.5722752330049439,0.1746284556521267,0.12246777316369184,0.9607449820026952,0.4573022697138245,0.6217740977273372,0.5695492634290764,0.09349911590989035,0.818840480198648],"type":"scatter","name":"y1","yaxis":"y1","x":[1,2,3,4,5,6,7,8,9,10]}], {"showlegend":true,"paper_bgcolor":"rgba(255, 255, 255, 1.000)","xaxis1":{"showticklabels":true,"gridwidth":0.5,"tickvals":[2.0,4.0,6.0,8.0,10.0],"visible":true,"ticks":"inside","range":[0.73,10.27],"domain":[0.05313137941090697,0.9931649168853892],"tickmode":"array","linecolor":"rgba(0, 0, 0, 1.000)","showgrid":true,"title":"","mirror":false,"tickangle":0,"showline":true,"gridcolor":"rgba(0, 0, 0, 0.100)","titlefont":{"color":"rgba(0, 0, 0, 1.000)","family":"sans-serif","size":15},"tickcolor":"rgb(0, 0, 0)","ticktext":["2","4","6","8","10"],"zeroline":false,"type":"-","tickfont":{"color":"rgba(0, 0, 0, 1.000)","family":"sans-serif","size":11},"zerolinecolor":"rgba(0, 0, 0, 1.000)","anchor":"y1"},"annotations":[],"height":384,"margin":{"l":0,"b":20,"r":0,"t":20},"plot_bgcolor":"rgba(255, 255, 255, 1.000)","yaxis1":{"showticklabels":true,"gridwidth":0.5,"tickvals":[0.2,0.4,0.6000000000000001,0.8],"visible":true,"ticks":"inside","range":[0.06748173992710621,0.9867623579854794],"domain":[0.0391878098571012,0.989747375328084],"tickmode":"array","linecolor":"rgba(0, 0, 0, 1.000)","showgrid":true,"title":"","mirror":false,"tickangle":0,"showline":true,"gridcolor":"rgba(0, 0, 0, 0.100)","titlefont":{"color":"rgba(0, 0, 0, 1.000)","family":"sans-serif","size":15},"tickcolor":"rgb(0, 0, 0)","ticktext":["0.2","0.4","0.6","0.8"],"zeroline":false,"type":"-","tickfont":{"color":"rgba(0, 0, 0, 1.000)","family":"sans-serif","size":11},"zerolinecolor":"rgba(0, 0, 0, 1.000)","anchor":"x1"},"legend":{"bordercolor":"rgba(0, 0, 0, 1.000)","bgcolor":"rgba(255, 255, 255, 1.000)","font":{"color":"rgba(0, 0, 0, 1.000)","family":"sans-serif","size":11},"y":1.0,"x":1.0},"width":576});
</script>

