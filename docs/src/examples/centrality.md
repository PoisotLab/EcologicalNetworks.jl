In this example, we will visualize different measures of centrality, using a
large food web.

```@example centr
using EcologicalNetworks
using EcologicalNetworksPlots
using Plots
using Plots.PlotMeasures
```

We will work on a quantitative intertidal food web:

```@example centr
N = convert(BinaryNetwork, pajek()[:ChesUpper])
```

We will then find a force-directed layout to visualize it:

```@example centr
I = initial(RandomInitialLayout, N)
for step in 1:200richness(N)
    position!(ForceAtlas2(1.2), I, N)
end
```

We can now show the different values of centrality on this plot:

## Degree centrality

```@example centr
plot(I, N)
scatter!(I, N, nodefill=centrality_degree(N), c=:YlGnBu, aspectratio=1, cbar=true)
```
