In this illustration, we will simulate extinctions of hosts, to show how the
package can be extended by using the core functions described in the "Interface"
section. Simply put, the goal of this example is to write a function to randomly
remove one host species, remove all parasite species that end up not connected
to a host, and measuring the effect of these extinctions on the remaining
network. Rather than measuring the network structure in the function, we will
return an array of networks to be manipulated later:

```@example ext
using EcologicalNetworks
using Plots
```

```@example ext
function extinctions(N::T) where {T <: AbstractBipartiteNetwork}

  # We start by making a copy of the network to extinguish
  Y = [copy(N)]

  # While there is at least one species remaining...
  while richness(last(Y)) > 1
    # We remove one species randomly
    remain = sample(species(last(Y); dims=2), richness(last(Y); dims=2)-1, replace=false)

    # Remaining species
    R = last(Y)[:,remain]
    simplify!(R)

    # Then add the simplified network (without the extinct species) to our collection
    push!(Y, copy(R))
  end
  return Y
end
```

One classical analysis is to remove host species, and count the richness of
parasite species, to measure their robustness to host extinctions -- this is
usually done with multiple scenarios for order of extinction, but we will focus
on the random order here. Even though `EcologicalNetworks` has a built-in
function for richness, we can write a small wrapper around it:

```@example ext
function parasite_richness(N::T) where {T<:BinaryNetwork}
  return richness(N; dims=1)
end
```

Writing multiple functions that take a single argument allows to chain them in a
very expressive way: for example, measuring the richness on all timesteps in a
simulation is `N |> extinctions .|> parasite_richness`, or alternatively,
`parasite_richness.(extinctions(N))`. In @fig:extinctions, we illustrate the
output of this analysis on 100 simulations (average and standard deviation) for
one of the networks.

```@example ext
N = web_of_life("A_HP_050")

X = Float64[]
Y = Float64[]
for i in 1:200
  timeseries = extinctions(N)
  path_l = parasite_richness.(timeseries)./richness(N; dims=1)
  prop_r = 1.0.-richness.(timeseries; dims=2)./richness(N; dims=2)
  append!(X, prop_r)
  append!(Y, path_l)
end
x = sort(unique(X))
y = zeros(Float64, length(x))
sy = zeros(Float64, length(x))
for (i, tx) in enumerate(x)
  y[i] = mean(Y[X.==tx])
  sy[i] = std(Y[X.==tx])
end

pl = plot(x, y, ribbon=sy, c=:black, fill=(:lightgrey), lw=2, ls=:dash, leg=false, margin = 10mm, grid=false, frame=:origin, xlim=(0,1), ylim=(0,1))
xaxis!(pl, "Proportion of hosts removed")
```
