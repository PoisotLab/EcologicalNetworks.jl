# Nestedness significance testing

```@setup nest_uc
using EcologicalNetwork
using Plots
using StatsBase
```

One common question after measuring the nestedness of a network is to compare it
to an expected value under various null models. In this use case, we will get
the networks from the Web of Life database, and focus on a random sample of 50
networks with 10 to 100 species.

```@example nest_uc
network_infos = filter(x -> 10 <= x.Species <= 100, web_of_life());
network_set = web_of_life.(getfield.(network_infos, :ID));
network_set = map(x -> typeof(x) <: QuantitativeNetwork ? convert(BinaryNetwork, x) : x, network_set);
network_set = sample(network_set, 50, replace=false)
length(network_set)
```

Because we will only consider nestedness at the scale of the network, we will
write a small function for convenience:

```@example nest_uc
nestedness(x) = η(x)[:network];
```

The next step is to write a function to generate random networks, using the
`null2` null model (where the probability of an interaction is relative to the
degree of both species). An additional constraint which we use is that only the
networks with the same richness and number of interactions, in which *all*
species have at least one interaction, are considered.

```@example nest_uc
function randomized(n)
    trials = simplify.(rand(null2(n), 10000))
    filter!(x -> richness(x) == richness(n), trials)
    filter!(x -> links(x) == links(n), trials)
    return trials
end
```

This may seem like a harsh criteria (it is), but most measures of network
structure covary with either richness, number of links, or both. Controlling for
these factors mean that we can focus on the changes in properties evaluated
independently from these variables.

As a next step, we will create an array to store the original nestedness, the
mean and standard deviation of the random network, and the number of succesful
random networks:

```@example nest_uc
output = zeros(Float64, (length(network_set), 4));
```

This is not the most elegant approach, but it will work for such a simple
example.

Once this is done, we can loop over all networks in `network_set`, and perform
the required analysis.

```@example nest_uc
for i in eachindex(network_set)
  draws = randomized(network_set[i])
  nest_values = nestedness.(draws)
  output[i,1] = nestedness(network_set[i])
  output[i,2] = mean(nest_values)
  output[i,3] = std(nest_values)
  output[i,4] = length(draws)
end
```

When this is done (it can take a while, and in actual situations should be
parallelized), we will remove any network with fewer than 10 random networks.

```@example nest_uc
valid = output[output[:,4].>10,:]
sorted = sortrows(valid, by=x->x[1])
size(sorted)
```

The actual plotting is done with `Plots.jl`:

```@example nest_uc
npl = scatter(sorted[:,2], yerror=sorted[:,3]./2.0, c=:black, lab="Random networks", m=:square, ms=1.5, legend=:top)
scatter!(npl, sorted[:,1], c=:grey, m=:circle, lab="Empirical value")
yaxis!(npl, (0.0, 1.0))
savefig(npl, "nest_test.png")
```

![nest_test.png](nest_test.png)
