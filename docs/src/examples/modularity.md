## Modularity

In this example, we will show how the modular structure of an ecological
network can be optimized. Finding the optimal modular structure can be a
time-consuming process, as it relies on heuristic which are not guaranteed to
converge to the global maximum. There is no elegant alternative to trying
multiple approaches, repeating the process multiple times, and having
some luck.

We will use again the first network from the @HadfKras14 dataset in this
example, which has a small number of species. For the first approach, we
will generate random partitions of the species across 3 to 12 modules, and
evaluate 20 replicate attempts for each of these combinations. The output
we are interested in is the number of modules, and the overall modularity
[@Barb07].

```julia
n = repeat(3:12, outer=20)
m = Array{Dict}(undef, length(n))

for i in eachindex(n)
  # Each run returns the network and its modules
  # We discard the network, and assign the modules to our object
  _, m[i] = n_random_modules(n[i])(N) |> x -> brim(x...)
end
```

Now that we have the modular partition for every attempt, we can count the
modules in it, and measure its modularity:

```julia
q = map(x -> Q(N,x), m);
c = (m .|> values |> collect) .|> unique .|> length;
```

The relationship between the two is represented in @fig:modularity. Out of
the `j length(c)` attempts, we want to get the most modular one, *i.e.* the
one with highest modularity. In some simple problems, there may be several
partitions with the highest value, so we can either take the first, or one
at random:

```julia
optimal = rand(findall(q.== maximum(q)));
best_m = m[optimal];
```

```julia; echo=false
p1 = scatter(c, q, c=:grey, msw=0.0, leg=false, frame=:origin, grid=false)
xaxis!(p1, "Number of modules")
yaxis!(p1, "Modularity", (0, 0.5))

I = initial(RandomInitialLayout, N)
for step in 1:4000
  position!(ForceDirectedLayout(2.5), I, N)
end
p2 = plot(I, N, aspectratio=1)
scatter!(p2, I, N, bipartite=true, nodefill=best_m, markercolor=:isolum)

plot(p1, p2, size=(700,300))
savefig("figures/modularity.pdf")
```

![Left, relationship between the number of modules in the optimized partition and its modularity. Right, representation of the network where every node is colored according to the module it belongs to in the optimal partition.](figures/modularity.pdf){#fig:modularity}

This partitions has `j c[optimal]` modules. `EcologicalNetworks` has other
routines for modularity, such as LP [@LiuMura09], and a modified version
of LP relying on simulated annealing. We can finally look at the functional
roles of the species.

```julia
roles = functional_cartography(N, best_m)
```

This function returns a tuple (an unmodifiable set of values) of coordinates
for every species, indicating its within-module contribution, and its
participation coefficient. These results can be plotted to separate species
in module hubs, network hubs, peripherals, and connectors (@fig:roles). Note
that in the context of ecological networks, this classification [following
@OlesBasc07] is commonly used. It derives from previous work by @GuimNune05
on metabolic networks, which subdivides the place in 7 (rather than 4)
regions. For the sake of completeness, we have added the 7 regions of the
@GuimNune05 to the plot as well.

```julia; echo=false
plot(Shape([-2, 2.5, 2.5, -2], [0, 0, 0.05, 0.05]), lab="", frame=:box, lc=:grey, opacity=0.3, c=:grey, lw=0.0, grid=false) #R1
plot!(Shape([-2, 2.5, 2.5, -2], [0.05, 0.05, 0.62, 0.62]), lab="", c=:transparent) #R2
plot!(Shape([-2, 2.5, 2.5, -2], [0.62, 0.62, 0.80, 0.80]), lab="", lc=:grey, opacity=0.3, c=:grey, lw=0.0) #R3
plot!(Shape([-2, 2.5, 2.5, -2], [0.80, 0.80, 1.0, 1.0]), lab="", c=:transparent) #R4

plot!(Shape([2.5, 3.0, 3.0, 2.5], [0, 0, 0.3, 0.3]), lab="", c=:transparent) #R5
plot!(Shape([2.5, 3.0, 3.0, 2.5], [0.3, 0.3, 0.75, 0.75]), lab="", lc=:grey, opacity=0.3, c=:grey, lw=0.0) #R6
plot!(Shape([2.5, 3.0, 3.0, 2.5], [0.75, 0.75, 1.0, 1.0]), lab="", c=:transparent) #R7

vline!([2.5], c=:black, ls=:dot, lw=2.0)
hline!([0.62], c=:black, ls=:dot, lw=2.0)
collect(values(roles)) |> x -> scatter!(x, leg=false, c=:white)
yaxis!("Among-module connectivity", (0,1))
xaxis!("Within-module degree", (-2, 3))
savefig("figures/roles.pdf")
```

![Functional roles of the species in the most modular partition found. All species score very low along both axes, making them "peripherals" -- this is a strong indication that the modular structure is not meaningful.](figures/roles.pdf){#fig:roles}
