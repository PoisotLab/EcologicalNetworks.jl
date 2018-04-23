---
title : Nestedness significance testing
author : Timothée Poisot
date : 11th April 2018
layout: default
---




The purpose of this case study is to illustrate how we can use the package to
perform significance testing. We will see how we can compare the measured value
of nestedness to random values derived from network permutations.

We start by loading a network, in this case the one by Fonseca & Ganade (1996).
This is a bipartite network.

````julia
N = fonseca_ganade_1996()
````





We will start by getting rid of the quantitative information. This is done by
converting our network to another type:

````julia
M = convert(BipartiteNetwork, N)
````





We will now measure the nestedness of the network, using the $\eta$ measure:

````julia
n0 = η(M);
````





This returns a dictionary with a value for the rows, the columns, and the entire
network.

````julia
n0
````


````
Dict{Symbol,Float64} with 3 entries:
  :rows    => 0.187648
  :network => 0.168149
  :columns => 0.148649
````





At this point, we will need to generate a few random matrices to test our
empirical measure against. We will focus on the Type II null model, in which the
probability of an interaction between two species is proportional to their
relative degrees. We will call this probabilistic template `T`:

````julia
T = null2(M)
````





This function will return another network, this time a probabilistic one.

````julia
typeof(T)
````


````
EcologicalNetwork.BipartiteProbabilisticNetwork{Float64,String}
````





We can draw a random sample based on this template:

````julia
rand(T)
````


````
EcologicalNetwork.BipartiteNetwork{String}(Bool[false false … false false
; false false … false false; … ; false false … false false; false fal
se … false true], String["Camponotus balzanii", "Azteca alfari", "Azteca 
isthmica", "Azteca aff. Isthmica", "Allomerus D", "Allomerus prancei", "All
omerus aff. Octoarticulata", "Solenops A", "Allomerus auripunctata", "Crema
togaster B"  …  "Crematogaster A", "Azteca TO", "Crematogaster C", "Aztec
a schummani", "Pseudomyrmex nigrescens", "Pseudomyrmex concolor", "Azteca D
", "Azteca polymorpha", "Crematogaster E", "Azteca Q"], String["Cecropia pu
rpuracens", "Cecropia concolor", "Cecropia distachya", "Cecropia ficifolia"
, "Pouruma heterophylla", "Hirtella myrmecophila", "Hirtella physophora", "
Duroia saccifera", "Cordia nodosa", "Cordia aff. Nodosa", "Tococa bullifera
", "Maieta guianensis", "Maieta poeppiggi", "Tachigali polyphylla", "Tachig
ali myrmecophila", "Amaioua aff. Guianensis"])
````





Of course, we would like to generate a larger sample -- so we can draw many
replicates at once:

````julia
random_draws = rand(T, 5000)
````





Some of these networks may be *degenerate*, *i.e.* they have species without
interactions. It is safer to remove them from our sample:

````julia
valid_draws = filter(x -> !isdegenerate(x), random_draws)
````





We are left with a smaller number of networks, but all of them have species
with at least one interaction. At this point, we can measure the nestedness
on all of these networks:

````julia
n_prime = map(x -> η(x)[:network], valid_draws)
````





We can also express most of this analysis as a single pipeline:

````julia
n_prime = N |>
    # Step 1 - remove interaction strength
    n -> convert(BipartiteNetwork, n) |>
    # Step 2 - generate the probability template
    null2 |>
    # Step 3 - draw random networks
    n -> rand(n, 40000) |>
    # Step 4 - remove degenerate networks
    n -> filter(x -> !isdegenerate(x), n) .|>
    # Step 5 - measure the nestedness
    n -> η(n)[:network]
````





This notation is more compact, and can help understand the flow of the analysis
better.

We can now figure out the *p*-value for this test (specifically, is the network
*less* nested than expected by chance), by measuring the proportion of randon
draws that are smaller than the empirical value:

````julia
p = sum(n_prime .<= n0[:network])./length(n_prime)
println("p ≈ $(round(p,3)), n = $(length(n_prime))
the network is $(p < 0.05 ? "less nested than" : "as nested as") expected by chance.")
````


````
p ≈ 0.039, n = 887
the network is less nested than expected by chance.
````





Take note that the number of random draws used for this example (
887) is **not enough** in most cases. Aim for anything above 10000.
Finally, we can also look at the distribution of these values (all of this code
is intended to make the final plot more palatable):

````julia
low, high = quantile(n_prime, [0.05, 0.95])
rectangle(w, h, x, y) = Shape(x + [0,w,w,0], y + [0,0,h,h])
pl = histogram(n_prime, fill=:lightgrey, c=:grey, lc=:grey, lw=1, framestyle=:zerolines, lab="Random draws", size=(900,300));
vline!(pl, [n0[:network]], lab="Empirical value", c=:black, ls=:dot);
plot!(pl, rectangle(low,120,0,0), opacity=.2, c=:orange, lab="Significance threshold", lw=0, lc=:orange);
plot!(pl, rectangle(0.4-high,120,high,0), opacity=.2, c=:orange, lab="", lw=0);
histogram!(pl, n_prime, fill=:lightgrey, c=:grey, lc=:grey, lw=1, lab="");
xaxis!(pl, (0.1, 0.4));
yaxis!(pl, (0.0, 120.0));
pl
````



<div id="4905e820-442a-4da9-ac11-9d94cc4d76f1" style="width:900px;height:300px;"></div>
<script>
PLOT = document.getElementById('4905e820-442a-4da9-ac11-9d94cc4d76f1');
Plotly.plot(PLOT, [{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.14,0.14,0.15000000000000002,0.15000000000000002,0.14,0.14],"showlegend":true,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"Random draws","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[2.0,0.0,0.0,2.0,2.0,2.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.15,0.15,0.16,0.16,0.15,0.15],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"Random draws","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[11.0,0.0,0.0,11.0,11.0,11.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.16,0.16,0.17,0.17,0.16,0.16],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"Random draws","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[32.0,0.0,0.0,32.0,32.0,32.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.16999999999999998,0.16999999999999998,0.18,0.18,0.16999999999999998,0.16999999999999998],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"Random draws","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[43.0,0.0,0.0,43.0,43.0,43.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.18,0.18,0.19,0.19,0.18,0.18],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"Random draws","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[59.0,0.0,0.0,59.0,59.0,59.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.19,0.19,0.2,0.2,0.19,0.19],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"Random draws","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[88.0,0.0,0.0,88.0,88.0,88.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.2,0.2,0.21000000000000002,0.21000000000000002,0.2,0.2],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"Random draws","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[88.0,0.0,0.0,88.0,88.0,88.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.21,0.21,0.22,0.22,0.21,0.21],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"Random draws","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[104.0,0.0,0.0,104.0,104.0,104.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.22,0.22,0.23,0.23,0.22,0.22],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"Random draws","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[102.0,0.0,0.0,102.0,102.0,102.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.22999999999999998,0.22999999999999998,0.24,0.24,0.22999999999999998,0.22999999999999998],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"Random draws","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[97.0,0.0,0.0,97.0,97.0,97.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.24,0.24,0.25,0.25,0.24,0.24],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"Random draws","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[83.0,0.0,0.0,83.0,83.0,83.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.25,0.25,0.26,0.26,0.25,0.25],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"Random draws","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[61.0,0.0,0.0,61.0,61.0,61.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.26,0.26,0.27,0.27,0.26,0.26],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"Random draws","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[37.0,0.0,0.0,37.0,37.0,37.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.27,0.27,0.28,0.28,0.27,0.27],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"Random draws","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[30.0,0.0,0.0,30.0,30.0,30.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.28,0.28,0.29000000000000004,0.29000000000000004,0.28,0.28],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"Random draws","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[19.0,0.0,0.0,19.0,19.0,19.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.29,0.29,0.3,0.3,0.29,0.29],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"Random draws","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[11.0,0.0,0.0,11.0,11.0,11.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.3,0.3,0.31,0.31,0.3,0.3],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"Random draws","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[6.0,0.0,0.0,6.0,6.0,6.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.31,0.31,0.32,0.32,0.31,0.31],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"Random draws","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[8.0,0.0,0.0,8.0,8.0,8.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.32,0.32,0.33,0.33,0.32,0.32],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"Random draws","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[1.0,0.0,0.0,1.0,1.0,1.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.33,0.33,0.34,0.34,0.33,0.33],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"Random draws","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[3.0,0.0,0.0,3.0,3.0,3.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.33999999999999997,0.33999999999999997,0.35,0.35,0.33999999999999997,0.33999999999999997],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"Random draws","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[2.0,0.0,0.0,2.0,2.0,2.0],"type":"scatter"},{"showlegend":true,"mode":"lines","xaxis":"x1","colorbar":{"title":""},"line":{"color":"rgba(0, 0, 0, 1.000)","shape":"linear","dash":"dot","width":1},"y":[-12000.0,12120.0],"type":"scatter","name":"Empirical value","yaxis":"y1","x":[0.16814855235282788,0.16814855235282788]},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.0,0.1698597555012087,0.1698597555012087,0.0,0.0],"showlegend":true,"mode":"lines","fillcolor":"rgba(255, 165, 0, 0.200)","name":"Significance threshold","line":{"color":"rgba(255, 165, 0, 0.200)","dash":"solid","width":0},"y":[0.0,0.0,120.0,120.0,0.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.2819673516556947,0.4,0.4,0.2819673516556947,0.2819673516556947],"showlegend":false,"mode":"lines","fillcolor":"rgba(255, 165, 0, 0.200)","name":"","line":{"color":"rgba(0, 0, 0, 0.200)","dash":"solid","width":0},"y":[0.0,0.0,120.0,120.0,0.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.14,0.14,0.15000000000000002,0.15000000000000002,0.14,0.14],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[2.0,0.0,0.0,2.0,2.0,2.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.15,0.15,0.16,0.16,0.15,0.15],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[11.0,0.0,0.0,11.0,11.0,11.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.16,0.16,0.17,0.17,0.16,0.16],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[32.0,0.0,0.0,32.0,32.0,32.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.16999999999999998,0.16999999999999998,0.18,0.18,0.16999999999999998,0.16999999999999998],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[43.0,0.0,0.0,43.0,43.0,43.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.18,0.18,0.19,0.19,0.18,0.18],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[59.0,0.0,0.0,59.0,59.0,59.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.19,0.19,0.2,0.2,0.19,0.19],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[88.0,0.0,0.0,88.0,88.0,88.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.2,0.2,0.21000000000000002,0.21000000000000002,0.2,0.2],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[88.0,0.0,0.0,88.0,88.0,88.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.21,0.21,0.22,0.22,0.21,0.21],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[104.0,0.0,0.0,104.0,104.0,104.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.22,0.22,0.23,0.23,0.22,0.22],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[102.0,0.0,0.0,102.0,102.0,102.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.22999999999999998,0.22999999999999998,0.24,0.24,0.22999999999999998,0.22999999999999998],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[97.0,0.0,0.0,97.0,97.0,97.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.24,0.24,0.25,0.25,0.24,0.24],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[83.0,0.0,0.0,83.0,83.0,83.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.25,0.25,0.26,0.26,0.25,0.25],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[61.0,0.0,0.0,61.0,61.0,61.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.26,0.26,0.27,0.27,0.26,0.26],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[37.0,0.0,0.0,37.0,37.0,37.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.27,0.27,0.28,0.28,0.27,0.27],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[30.0,0.0,0.0,30.0,30.0,30.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.28,0.28,0.29000000000000004,0.29000000000000004,0.28,0.28],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[19.0,0.0,0.0,19.0,19.0,19.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.29,0.29,0.3,0.3,0.29,0.29],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[11.0,0.0,0.0,11.0,11.0,11.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.3,0.3,0.31,0.31,0.3,0.3],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[6.0,0.0,0.0,6.0,6.0,6.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.31,0.31,0.32,0.32,0.31,0.31],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[8.0,0.0,0.0,8.0,8.0,8.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.32,0.32,0.33,0.33,0.32,0.32],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[1.0,0.0,0.0,1.0,1.0,1.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.33,0.33,0.34,0.34,0.33,0.33],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[3.0,0.0,0.0,3.0,3.0,3.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.33999999999999997,0.33999999999999997,0.35,0.35,0.33999999999999997,0.33999999999999997],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[2.0,0.0,0.0,2.0,2.0,2.0],"type":"scatter"}], {"showlegend":true,"paper_bgcolor":"rgba(255, 255, 255, 1.000)","xaxis1":{"showticklabels":true,"gridwidth":0.5,"tickvals":[0.1,0.2,0.30000000000000004,0.4],"visible":true,"ticks":"inside","range":[0.1,0.4],"domain":[0.03400408282298046,0.9956255468066492],"tickmode":"array","linecolor":"rgba(0, 0, 0, 1.000)","showgrid":true,"title":"","mirror":false,"tickangle":0,"showline":false,"gridcolor":"rgba(0, 0, 0, 0.100)","titlefont":{"color":"rgba(0, 0, 0, 1.000)","family":"sans-serif","size":15},"tickcolor":"rgba(0, 0, 0, 0.000)","ticktext":["0.1","0.2","0.3","0.4"],"zeroline":true,"type":"-","tickfont":{"color":"rgba(0, 0, 0, 1.000)","family":"sans-serif","size":11},"zerolinecolor":"rgba(0, 0, 0, 1.000)","anchor":"y1"},"annotations":[],"height":300,"margin":{"l":0,"b":20,"r":0,"t":20},"plot_bgcolor":"rgba(255, 255, 255, 1.000)","yaxis1":{"showticklabels":true,"gridwidth":0.5,"tickvals":[0.0,20.0,40.0,60.0,80.0,100.0,120.0],"visible":true,"ticks":"inside","range":[0.0,120.0],"domain":[0.050160396617089535,0.9868766404199475],"tickmode":"array","linecolor":"rgba(0, 0, 0, 1.000)","showgrid":true,"title":"","mirror":false,"tickangle":0,"showline":false,"gridcolor":"rgba(0, 0, 0, 0.100)","titlefont":{"color":"rgba(0, 0, 0, 1.000)","family":"sans-serif","size":15},"tickcolor":"rgba(0, 0, 0, 0.000)","ticktext":["0","20","40","60","80","100","120"],"zeroline":true,"type":"-","tickfont":{"color":"rgba(0, 0, 0, 1.000)","family":"sans-serif","size":11},"zerolinecolor":"rgba(0, 0, 0, 1.000)","anchor":"x1"},"legend":{"bordercolor":"rgba(0, 0, 0, 1.000)","bgcolor":"rgba(255, 255, 255, 1.000)","font":{"color":"rgba(0, 0, 0, 1.000)","family":"sans-serif","size":11},"y":1.0,"x":1.0},"width":900});
</script>

