---
title : Nestedness significance testing
author : Timothée Poisot
date : 11th April 2018
layout: default
---




The purpose of this case study is to illustrate how we can use the package to
perform significance testing. We will see how we can compare the measured value
of nestedness to random values derived from network permutations.

We start by loading a network, in this case the one by TODO. This is a bipartite
network.

````julia
N = web_of_life("A_HP_017")
````





We will start by getting rid of the quantitative information. This is done by
converting our network to another type:

````julia
M = convert(BinaryNetwork, N)
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
  :rows    => 0.979592
  :network => 0.96348
  :columns => 0.947368
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
EcologicalNetwork.BipartiteNetwork{String}(Bool[true true … false true; t
rue true … true false; … ; true false … false true; true false … fa
lse false], String["Megabothris calcarifer", "Ctenophthalmus congeneroides"
, "Neopsylla bidentatiformis", "Stenoponia sidimi", "Nosopsyllus fasciatus"
, "Ceratophyllus anisus", "Rhadinopsylla insolita", "Peromyscopsylla ostsib
irica", "Hystrichopsylla microti"], String["Apodemus agrarius", "Microtus f
ortis", "Apodemus peninsulae", "Crocidura suaveolens", "Tamias sibiricus"])
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
    n -> rand(n, 10000) |>
    # Step 4 - remove degenerate networks
    n -> filter(x -> !isdegenerate(x), n) .|>
    # Step 5 - measure the nestedness
    n -> η(n)[:network]
````





This notation is more compact, and can help understand the flow of the analysis
better.

We can approximate the *p*-value for this test (specifically, is the network
*more* nested than expected by chance), by measuring the proportion of randon
draws that are larger than the empirical value:

````julia
p = sum(n_prime .> n0[:network])./length(n_prime)
println("p ≈ $(round(p,3)), n = $(length(n_prime))
the network is $(p < 0.05 ? "more nested than" : "not more nested than") expected by chance.")
````


````
p ≈ 0.001, n = 4415
the network is more nested than expected by chance.
````





Take note that the number of random draws used for this example (
4415) is **not enough** in most cases. Aim for anything above 10000.
Finally, we can also look at the distribution of these values (all of this code
is intended to make the final plot more palatable):

````julia
low, high = quantile(n_prime, [0.05, 0.95])
rectangle(w, h, x, y) = Shape(x + [0,w,w,0], y + [0,0,h,h])
pl = histogram(n_prime, fill=:lightgrey, c=:grey, lc=:grey, lw=1, framestyle=:zerolines, lab="Random draws", size=(900,300));
vline!(pl, [n0[:network]], lab="Empirical value", c=:black, ls=:dot);
plot!(pl, rectangle(low,400,0,0), opacity=.2, c=:orange, lab="Significance threshold", lw=0, lc=:orange);
plot!(pl, rectangle(1.0-high,400,high,0), opacity=.2, c=:orange, lab="", lw=0);
histogram!(pl, n_prime, fill=:lightgrey, c=:grey, lc=:grey, lw=1, lab="");
xaxis!(pl, (0.0, 1.0));
yaxis!(pl, (0.0, 400.0));
pl
````



<div id="8d7cfd4c-b34f-4d23-9b76-b2b25fc405fe" style="width:900px;height:300px;"></div>
<script>
PLOT = document.getElementById('8d7cfd4c-b34f-4d23-9b76-b2b25fc405fe');
Plotly.plot(PLOT, [{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.3,0.3,0.32,0.32,0.3,0.3],"showlegend":true,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"Random draws","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[4.0,0.0,0.0,4.0,4.0,4.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.32,0.32,0.34,0.34,0.32,0.32],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"Random draws","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[5.0,0.0,0.0,5.0,5.0,5.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.33999999999999997,0.33999999999999997,0.36,0.36,0.33999999999999997,0.33999999999999997],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"Random draws","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[4.0,0.0,0.0,4.0,4.0,4.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.36,0.36,0.38,0.38,0.36,0.36],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"Random draws","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[13.0,0.0,0.0,13.0,13.0,13.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.38,0.38,0.4,0.4,0.38,0.38],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"Random draws","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[15.0,0.0,0.0,15.0,15.0,15.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.4,0.4,0.42000000000000004,0.42000000000000004,0.4,0.4],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"Random draws","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[25.0,0.0,0.0,25.0,25.0,25.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.42,0.42,0.44,0.44,0.42,0.42],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"Random draws","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[25.0,0.0,0.0,25.0,25.0,25.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.44,0.44,0.46,0.46,0.44,0.44],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"Random draws","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[52.0,0.0,0.0,52.0,52.0,52.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.45999999999999996,0.45999999999999996,0.48,0.48,0.45999999999999996,0.45999999999999996],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"Random draws","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[49.0,0.0,0.0,49.0,49.0,49.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.48,0.48,0.5,0.5,0.48,0.48],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"Random draws","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[82.0,0.0,0.0,82.0,82.0,82.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.5,0.5,0.52,0.52,0.5,0.5],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"Random draws","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[130.0,0.0,0.0,130.0,130.0,130.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.52,0.52,0.54,0.54,0.52,0.52],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"Random draws","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[137.0,0.0,0.0,137.0,137.0,137.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.54,0.54,0.56,0.56,0.54,0.54],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"Random draws","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[192.0,0.0,0.0,192.0,192.0,192.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.56,0.56,0.5800000000000001,0.5800000000000001,0.56,0.56],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"Random draws","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[186.0,0.0,0.0,186.0,186.0,186.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.58,0.58,0.6,0.6,0.58,0.58],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"Random draws","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[292.0,0.0,0.0,292.0,292.0,292.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.6,0.6,0.62,0.62,0.6,0.6],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"Random draws","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[256.0,0.0,0.0,256.0,256.0,256.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.62,0.62,0.64,0.64,0.62,0.62],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"Random draws","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[310.0,0.0,0.0,310.0,310.0,310.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.64,0.64,0.66,0.66,0.64,0.64],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"Random draws","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[344.0,0.0,0.0,344.0,344.0,344.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.66,0.66,0.68,0.68,0.66,0.66],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"Random draws","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[302.0,0.0,0.0,302.0,302.0,302.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.6799999999999999,0.6799999999999999,0.7,0.7,0.6799999999999999,0.6799999999999999],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"Random draws","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[316.0,0.0,0.0,316.0,316.0,316.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.7,0.7,0.72,0.72,0.7,0.7],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"Random draws","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[322.0,0.0,0.0,322.0,322.0,322.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.72,0.72,0.74,0.74,0.72,0.72],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"Random draws","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[318.0,0.0,0.0,318.0,318.0,318.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.74,0.74,0.76,0.76,0.74,0.74],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"Random draws","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[241.0,0.0,0.0,241.0,241.0,241.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.76,0.76,0.78,0.78,0.76,0.76],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"Random draws","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[187.0,0.0,0.0,187.0,187.0,187.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.78,0.78,0.8,0.8,0.78,0.78],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"Random draws","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[161.0,0.0,0.0,161.0,161.0,161.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.8,0.8,0.8200000000000001,0.8200000000000001,0.8,0.8],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"Random draws","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[135.0,0.0,0.0,135.0,135.0,135.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.82,0.82,0.84,0.84,0.82,0.82],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"Random draws","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[110.0,0.0,0.0,110.0,110.0,110.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.84,0.84,0.86,0.86,0.84,0.84],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"Random draws","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[91.0,0.0,0.0,91.0,91.0,91.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.86,0.86,0.88,0.88,0.86,0.86],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"Random draws","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[44.0,0.0,0.0,44.0,44.0,44.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.88,0.88,0.9,0.9,0.88,0.88],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"Random draws","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[30.0,0.0,0.0,30.0,30.0,30.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.9,0.9,0.92,0.92,0.9,0.9],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"Random draws","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[16.0,0.0,0.0,16.0,16.0,16.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.9199999999999999,0.9199999999999999,0.94,0.94,0.9199999999999999,0.9199999999999999],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"Random draws","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[8.0,0.0,0.0,8.0,8.0,8.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.94,0.94,0.96,0.96,0.94,0.94],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"Random draws","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[9.0,0.0,0.0,9.0,9.0,9.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.96,0.96,0.98,0.98,0.96,0.96],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"Random draws","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[3.0,0.0,0.0,3.0,3.0,3.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.98,0.98,1.0,1.0,0.98,0.98],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"Random draws","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[0.0,0.0,0.0,0.0,0.0,0.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[1.0,1.0,1.02,1.02,1.0,1.0],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"Random draws","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[1.0,0.0,0.0,1.0,1.0,1.0],"type":"scatter"},{"showlegend":true,"mode":"lines","xaxis":"x1","colorbar":{"title":""},"line":{"color":"rgba(0, 0, 0, 1.000)","shape":"linear","dash":"dot","width":1},"y":[-40000.0,40400.0],"type":"scatter","name":"Empirical value","yaxis":"y1","x":[0.9634801288936627,0.9634801288936627]},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.0,0.4865319865319865,0.4865319865319865,0.0,0.0],"showlegend":true,"mode":"lines","fillcolor":"rgba(255, 165, 0, 0.200)","name":"Significance threshold","line":{"color":"rgba(255, 165, 0, 0.200)","dash":"solid","width":0},"y":[0.0,0.0,400.0,400.0,0.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.8359873242226183,1.0,1.0,0.8359873242226183,0.8359873242226183],"showlegend":false,"mode":"lines","fillcolor":"rgba(255, 165, 0, 0.200)","name":"","line":{"color":"rgba(0, 0, 0, 0.200)","dash":"solid","width":0},"y":[0.0,0.0,400.0,400.0,0.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.3,0.3,0.32,0.32,0.3,0.3],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[4.0,0.0,0.0,4.0,4.0,4.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.32,0.32,0.34,0.34,0.32,0.32],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[5.0,0.0,0.0,5.0,5.0,5.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.33999999999999997,0.33999999999999997,0.36,0.36,0.33999999999999997,0.33999999999999997],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[4.0,0.0,0.0,4.0,4.0,4.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.36,0.36,0.38,0.38,0.36,0.36],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[13.0,0.0,0.0,13.0,13.0,13.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.38,0.38,0.4,0.4,0.38,0.38],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[15.0,0.0,0.0,15.0,15.0,15.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.4,0.4,0.42000000000000004,0.42000000000000004,0.4,0.4],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[25.0,0.0,0.0,25.0,25.0,25.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.42,0.42,0.44,0.44,0.42,0.42],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[25.0,0.0,0.0,25.0,25.0,25.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.44,0.44,0.46,0.46,0.44,0.44],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[52.0,0.0,0.0,52.0,52.0,52.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.45999999999999996,0.45999999999999996,0.48,0.48,0.45999999999999996,0.45999999999999996],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[49.0,0.0,0.0,49.0,49.0,49.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.48,0.48,0.5,0.5,0.48,0.48],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[82.0,0.0,0.0,82.0,82.0,82.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.5,0.5,0.52,0.52,0.5,0.5],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[130.0,0.0,0.0,130.0,130.0,130.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.52,0.52,0.54,0.54,0.52,0.52],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[137.0,0.0,0.0,137.0,137.0,137.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.54,0.54,0.56,0.56,0.54,0.54],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[192.0,0.0,0.0,192.0,192.0,192.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.56,0.56,0.5800000000000001,0.5800000000000001,0.56,0.56],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[186.0,0.0,0.0,186.0,186.0,186.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.58,0.58,0.6,0.6,0.58,0.58],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[292.0,0.0,0.0,292.0,292.0,292.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.6,0.6,0.62,0.62,0.6,0.6],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[256.0,0.0,0.0,256.0,256.0,256.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.62,0.62,0.64,0.64,0.62,0.62],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[310.0,0.0,0.0,310.0,310.0,310.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.64,0.64,0.66,0.66,0.64,0.64],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[344.0,0.0,0.0,344.0,344.0,344.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.66,0.66,0.68,0.68,0.66,0.66],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[302.0,0.0,0.0,302.0,302.0,302.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.6799999999999999,0.6799999999999999,0.7,0.7,0.6799999999999999,0.6799999999999999],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[316.0,0.0,0.0,316.0,316.0,316.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.7,0.7,0.72,0.72,0.7,0.7],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[322.0,0.0,0.0,322.0,322.0,322.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.72,0.72,0.74,0.74,0.72,0.72],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[318.0,0.0,0.0,318.0,318.0,318.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.74,0.74,0.76,0.76,0.74,0.74],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[241.0,0.0,0.0,241.0,241.0,241.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.76,0.76,0.78,0.78,0.76,0.76],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[187.0,0.0,0.0,187.0,187.0,187.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.78,0.78,0.8,0.8,0.78,0.78],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[161.0,0.0,0.0,161.0,161.0,161.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.8,0.8,0.8200000000000001,0.8200000000000001,0.8,0.8],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[135.0,0.0,0.0,135.0,135.0,135.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.82,0.82,0.84,0.84,0.82,0.82],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[110.0,0.0,0.0,110.0,110.0,110.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.84,0.84,0.86,0.86,0.84,0.84],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[91.0,0.0,0.0,91.0,91.0,91.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.86,0.86,0.88,0.88,0.86,0.86],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[44.0,0.0,0.0,44.0,44.0,44.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.88,0.88,0.9,0.9,0.88,0.88],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[30.0,0.0,0.0,30.0,30.0,30.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.9,0.9,0.92,0.92,0.9,0.9],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[16.0,0.0,0.0,16.0,16.0,16.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.9199999999999999,0.9199999999999999,0.94,0.94,0.9199999999999999,0.9199999999999999],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[8.0,0.0,0.0,8.0,8.0,8.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.94,0.94,0.96,0.96,0.94,0.94],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[9.0,0.0,0.0,9.0,9.0,9.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.96,0.96,0.98,0.98,0.96,0.96],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[3.0,0.0,0.0,3.0,3.0,3.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[0.98,0.98,1.0,1.0,0.98,0.98],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[0.0,0.0,0.0,0.0,0.0,0.0],"type":"scatter"},{"xaxis":"x1","fill":"tozeroy","yaxis":"y1","x":[1.0,1.0,1.02,1.02,1.0,1.0],"showlegend":false,"mode":"lines","fillcolor":"rgba(211, 211, 211, 1.000)","name":"","line":{"color":"rgba(128, 128, 128, 1.000)","dash":"solid","width":1},"y":[1.0,0.0,0.0,1.0,1.0,1.0],"type":"scatter"}], {"showlegend":true,"paper_bgcolor":"rgba(255, 255, 255, 1.000)","xaxis1":{"showticklabels":true,"gridwidth":0.5,"tickvals":[0.0,0.2,0.4,0.6000000000000001,0.8,1.0],"visible":true,"ticks":"inside","range":[0.0,1.0],"domain":[0.03400408282298046,0.9956255468066492],"tickmode":"array","linecolor":"rgba(0, 0, 0, 1.000)","showgrid":true,"title":"","mirror":false,"tickangle":0,"showline":false,"gridcolor":"rgba(0, 0, 0, 0.100)","titlefont":{"color":"rgba(0, 0, 0, 1.000)","family":"sans-serif","size":15},"tickcolor":"rgba(0, 0, 0, 0.000)","ticktext":["0.0","0.2","0.4","0.6","0.8","1.0"],"zeroline":true,"type":"-","tickfont":{"color":"rgba(0, 0, 0, 1.000)","family":"sans-serif","size":11},"zerolinecolor":"rgba(0, 0, 0, 1.000)","anchor":"y1"},"annotations":[],"height":300,"margin":{"l":0,"b":20,"r":0,"t":20},"plot_bgcolor":"rgba(255, 255, 255, 1.000)","yaxis1":{"showticklabels":true,"gridwidth":0.5,"tickvals":[0.0,100.0,200.0,300.0,400.0],"visible":true,"ticks":"inside","range":[0.0,400.0],"domain":[0.050160396617089535,0.9868766404199475],"tickmode":"array","linecolor":"rgba(0, 0, 0, 1.000)","showgrid":true,"title":"","mirror":false,"tickangle":0,"showline":false,"gridcolor":"rgba(0, 0, 0, 0.100)","titlefont":{"color":"rgba(0, 0, 0, 1.000)","family":"sans-serif","size":15},"tickcolor":"rgba(0, 0, 0, 0.000)","ticktext":["0","100","200","300","400"],"zeroline":true,"type":"-","tickfont":{"color":"rgba(0, 0, 0, 1.000)","family":"sans-serif","size":11},"zerolinecolor":"rgba(0, 0, 0, 1.000)","anchor":"x1"},"legend":{"bordercolor":"rgba(0, 0, 0, 1.000)","bgcolor":"rgba(255, 255, 255, 1.000)","font":{"color":"rgba(0, 0, 0, 1.000)","family":"sans-serif","size":11},"y":1.0,"x":1.0},"width":900});
</script>

