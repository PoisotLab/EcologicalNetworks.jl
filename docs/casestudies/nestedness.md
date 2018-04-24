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
; false false … false false; … ; false false … true false; false fals
e … false false], String["Camponotus balzanii", "Azteca alfari", "Azteca 
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
p ≈ 0.049, n = 900
the network is less nested than expected by chance.
````





Take note that the number of random draws used for this example (
900) is **not enough** in most cases. Aim for anything above 10000.
Finally, we can also look at the distribution of these values (all of this code
is intended to make the final plot more palatable):

````julia
low, high = quantile(n_prime, [0.05, 0.95])
rectangle(w, h, x, y) = Shape(x + [0,w,w,0], y + [0,0,h,h])
pl = histogram(n_prime, fill=:lightgrey, c=:grey, lc=:grey, lw=1, framestyle=:zerolines, lab="Random draws", size=(900,300));
````


<pre class="julia-error">
ERROR: UndefVarError: histogram not defined
</pre>


````julia
vline!(pl, [n0[:network]], lab="Empirical value", c=:black, ls=:dot);
````


<pre class="julia-error">
ERROR: UndefVarError: vline&#33; not defined
</pre>


````julia
plot!(pl, rectangle(low,120,0,0), opacity=.2, c=:orange, lab="Significance threshold", lw=0, lc=:orange);
````


<pre class="julia-error">
ERROR: UndefVarError: plot&#33; not defined
</pre>


````julia
plot!(pl, rectangle(0.4-high,120,high,0), opacity=.2, c=:orange, lab="", lw=0);
````


<pre class="julia-error">
ERROR: UndefVarError: plot&#33; not defined
</pre>


````julia
histogram!(pl, n_prime, fill=:lightgrey, c=:grey, lc=:grey, lw=1, lab="");
````


<pre class="julia-error">
ERROR: UndefVarError: histogram&#33; not defined
</pre>


````julia
xaxis!(pl, (0.1, 0.4));
````


<pre class="julia-error">
ERROR: UndefVarError: xaxis&#33; not defined
</pre>


````julia
yaxis!(pl, (0.0, 120.0));
````


<pre class="julia-error">
ERROR: UndefVarError: yaxis&#33; not defined
</pre>


````julia
pl
````


<pre class="julia-error">
ERROR: UndefVarError: pl not defined
</pre>

