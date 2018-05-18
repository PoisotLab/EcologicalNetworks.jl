# Nestedness significance testing

```@setup betadiv_uc
using EcologicalNetwork
using Plots
using StatsBase
```


In this example, we will explore the dissimilarity of a series of

```@example betadiv_uc
site = "Morne Seychellois National Park";
seychelles_id = getfield.(filter(x -> contains(x.Locality_of_Study, site), web_of_life()), :ID);
seychelles = convert.(BinaryNetwork, web_of_life.(seychelles_id));
length(seychelles)
```

## Rarefaction curves

```@example betadiv_uc
sites = rand(1:length(seychelles), 200)
S = zeros(Int64, length(sites))
L = zeros(Int64, length(sites))
for i in eachindex(sites)
    n = sites[i]
    sampled = sample(seychelles, n, replace=false)
    metaweb = reduce(union, sampled)
    S[i] = richness(metaweb)
    L[i] = links(metaweb)
end
```

```@example betadiv_uc
scatter(sites, S, legend=:topleft, lab="... species", frame=:origin)
scatter!(sites, L, lab="... interactions")
xaxis!("Number of sites")
yaxis!("Number of ...")
savefig("bd_rarefaction.png")
```

![](bd_rarefaction.png)

```@example betadiv_uc
scatter(sites, L./S.^2, lab="", frame=:origin)
xaxis!("Number of sites")
yaxis!("Connectance")
savefig("bd_connectance.png")
```

![](bd_connectance.png)

## Similarity

```@example betadiv_uc
D = KGL11.([βos(i,j) for i in seychelles, j in seychelles])
heatmap(D, c=:Greens, aspectratio=1)
savefig("bd_similarity.png")
```

![](bd_similarity.png)
