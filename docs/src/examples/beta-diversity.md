
# Network beta-diversity

In this section, we will measure the dissimilarity between bipartite
host-parasite networks.

```@example betadiv
using EcologicalNetworks
using Plots
```

We use networks that span the entirety of Eurasia. Because these networks are
originally quantitative, we will remove the information on interaction strength
using `convert`. Note that we convert to an union type (`BinaryNetwork`) -- the
`convert` function will select the appropriate network type to return based on
the partiteness. The core operations on sets (`union`, `diff`, and `intersect`)
are implemented for the `BinaryNetwork` type. As such, generating the "metaweb"
(*i.e.* the list of all species and all interactions in the complete dataset)
is:

```@example betadiv
all_hp_data = filter(x -> occursin("Hadfield", x.Reference), web_of_life());
ids = getfield.(all_hp_data, :ID);
networks = convert.(BinaryNetwork, web_of_life.(ids));
metaweb = reduce(union, networks)
```

From this metaweb, we can measure $\beta_{OS}'$, *i.e.* the dissimilarity of
every network to the expectation in the metaweb. Measuring the distance between
two networks is done in two steps. Dissimilarity is first partitioned into three
components (common elements, and elements unique to both samples), then the
value is measured based on the cardinality of these components. The functions to
generate the partitions are `βos` (dissimilarity of interactions between shared
species), `βs` (dissimilarity of species composition), and `βwn` (whole network
dissimilarity). The output of these functions is passed to one of the functions
to measure the actual $β$-diversity.

```@example betadiv
βcomponents = [βos(metaweb, n) for n in networks];
βosprime = KGL02.(βcomponents);
```

Finally, we measure the pairwise distance between all networks (because we use a
symmetric measure, we only need $n\times(n-1)$ distances):

```@example betadiv
S, OS, WN = Float64[], Float64[], Float64[]
for i in 1:(length(networks)-1)
  for j in (i+1):length(networks)
    push!(S, KGL02(βs(networks[i], networks[j])))
    push!(OS, KGL02(βos(networks[i], networks[j])))
    push!(WN, KGL02(βwn(networks[i], networks[j])))
  end
end
```

We can now visualize these data:

```@example betadiv
p1 = histogram(βosprime, frame=:origin, bins=20, c=:white, leg=false, grid=false)
xaxis!(p1, "Difference to metaweb", (0,1))
yaxis!(p1, (0,10))

p2 = plot([0,1],[0,1], c=:grey, ls=:dash, frame=:origin, grid=false, lab="", legend=:bottomleft)
scatter!(p2, S, OS, mc=:black, lab="shared sp.", msw=0.0)
scatter!(p2, S, WN, mc=:lightgrey, lab="all sp.", msw=0.0, m=:diamond)
xaxis!(p2, "Species dissimilarity", (0,1))
yaxis!(p2, "Network dissimilarity", (0,1))

plot(p1,p2, size=(700,300))
```