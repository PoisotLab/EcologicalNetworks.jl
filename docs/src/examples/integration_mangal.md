# Integration with Mangal.jl

Here we provide an example use case to get you started with `EcologicalNetworks.jl`. We show how to analyse meaningful network properties using all networks archived on the [`mangal.io`](https://mangal.io/#/) online database. We will create two plots: (1) the association between the number of species and the number of links in different types of networks, and (2) the association between species richness, connectance, nestedness, and modularity in food webs.

To conduct these analyses, we need to upload the following packages:

```julia
using EcologicalNetworks
using Mangal
using DataFrames
using Plots
```

We first retrieve relevant metadata for all networks archived on `mangal.io`. We count the number of species $S$ and the total number of interactions $L$ in each network, as well as their numbers of interactions of predation, of herbivory, of mutualism, and of parasitism. We store these information in a data frame along with the networks' ID numbers.

```julia
number_of_networks = count(MangalNetwork)
count_per_page = 100
number_of_pages = convert(Int, ceil(number_of_networks/count_per_page))

mangal_networks = DataFrame(fill(Int64, 7),
                 [:id, :S, :L, :pred, :herb, :mutu, :para],
                 number_of_networks)

global cursor = 1
@progress "Paging networks" for page in 1:number_of_pages
    global cursor
    networks_in_page = Mangal.networks("count" => count_per_page, "page" => page-1)
    @progress "Counting items" for current_network in networks_in_page
        S = count(MangalNode, current_network)
        L = count(MangalInteraction, current_network)
        pred = count(MangalInteraction, current_network, "type" => "predation")
        herb = count(MangalInteraction, current_network, "type" => "herbivory")
        mutu = count(MangalInteraction, current_network, "type" => "mutualism")
        para = count(MangalInteraction, current_network, "type" => "parasitism")
        mangal_networks[cursor,:] .= (current_network.id, S, L, pred, herb, mutu, para)
        cursor = cursor + 1
    end
end
```

We can classify all networks according to their most frequent type of interactions. Note that trophic interactions in food webs comprise interactions of predation and of herbivory. Note also that we discard small networks having less than 5 interactions for reliability reasons.

```julia
# number of trophic interactions
mangal_networks.foodweb = mangal_networks.pred .+ mangal_networks.herb

# number of other types of interactions
mangal_networks.other = mangal_networks.L .- mangal_networks.foodweb .- mangal_networks.mutu .- mangal_networks.para

# discard networks with less than 5 links
mangal_networks2 = mangal_networks[mangal_networks.L .> 4, :]

# classify networks
number_interactions_max_type = maximum.(eachrow(mangal_networks2[:,[:mutu, :para,:foodweb,:other]]))

foodwebs = mangal_networks2[mangal_networks2[:foodweb] .== number_interactions_max_type ,:]
parasitism_webs = mangal_networks2[mangal_networks2[:para] .== number_interactions_max_type ,:]
mutualism_webs = mangal_networks2[mangal_networks2[:mutu] .== number_interactions_max_type ,:]
other_webs = mangal_networks2[mangal_networks2[:other] .== number_interactions_max_type ,:]
```

The association between the number of species and the number of links in different types of networks can then be plotted, using a given color palette:

```julia

# color palette
pal = (
    foodwebs=RGB(204/255,121/255,167/255),
    parasitism=RGB(230/255,159/255,0/255),
    mutualism=RGB(0/255,158/255,115/255),
    other=RGB(86/255,190/255,233/255),
    )

# plot
scatter(mutualism_webs.S, mutualism_webs.L,
    alpha=0.2, color=pal.mutualism, markersize=5, markershape=:rect,
    lab="mutualism",
    legend=:topleft, foreground_color_legend=nothing, background_color_legend=:white,
    dpi=1000, framestyle=:box)
scatter!(parasitism_webs.S, parasitism_webs.L,
    alpha=0.2, color=pal.parasitism,  markersize=5, markershape=:diamond,
    lab="parasitism")
scatter!(foodwebs.S, foodwebs.L,
    alpha=0.2, color=pal.foodwebs, markersize=5,
    lab="food webs")
scatter!(other_webs.S, other_webs.L,
    alpha=0.2, color=pal.other,  markersize=5, markershape=:utriangle,
    lab="other types")
xaxis!(:log, "Number of species")
yaxis!(:log, "Number of links")
```

![Association between the number of species (nodes) and the number of links (edges) in ecological networks archived on `mangal.io`. Networks with less than 5 interactions are discarded. Different types of interactions can be listed within the same network. We classify all networks according to their most frequent type of interactions. ](fig/LS.png)

Further analysis of food-web structure are conducted using `EcologicalNetworks.jl`. We first read food webs from `mangal.io` using their ID numbers. We then need to convert the type of these MangalNetworks objects to UnipartiteNetworks, when possible.

```julia

mangal_foodwebs = network.(foodwebs.id)

unipartite_foodwebs=[]

for i in eachindex(mangal_foodwebs)
    try
        unipartite_foodweb = convert(UnipartiteNetwork, mangal_foodwebs[i])
        push!(unipartite_foodwebs, unipartite_foodweb)
    catch
        println("Cannot convert mangal food web $(i) to a unipartite network")
    end
end
```

We can then compute any measure supported by `EcologicalNetworks.jl` on these UnipartiteNetworks. In this example, we compute species richness, connectance, nestedness, and modularity.

```julia
foodweb_measures = DataFrame(fill(Float64, 4),
                 [:rich, :connect, :nested, :modul],
                 length(unipartite_foodwebs))

# species richness
foodweb_measures.rich = richness.(unipartite_foodwebs)

# connectance
foodweb_measures.connect = connectance.(unipartite_foodwebs)

# nestedness
foodweb_measures.nested = ρ.(unipartite_foodwebs)

# modularity (BRIM algorithm)
number_of_modules = repeat(3:15, outer=100)
modules = Array{Dict}(undef, length(number_of_modules))

for i in eachindex(unipartite_foodwebs)
    current_network = unipartite_foodwebs[i]
    for j in eachindex(number_of_modules)
        _, modules[j] = n_random_modules(number_of_modules[j])(current_network) |> x -> brim(x...)
    end
    partition_modularity = map(x -> Q(current_network,x), modules);
    foodweb_measures.modul[i] = maximum(partition_modularity)
end
```

Finally, the association between these food-web measures can be plotted. Here marker size is proportional to species richness.

```julia
plotA = scatter(foodweb_measures.connect, foodweb_measures.nested,
    markersize=foodweb_measures.rich ./ 30,
    alpha=0.6, color=pal.foodwebs,
    lab="",
    dpi=1000, framestyle=:box)
xaxis!("Connectance")
yaxis!((0.4,0.9), "Nestedness")

plotB = scatter(foodweb_measures.connect, foodweb_measures.modul,
    markersize=foodweb_measures.rich ./ 30,
    alpha=0.6, color=pal.foodwebs,
    lab="",
    dpi=1000, framestyle=:box)
xaxis!("Connectance")
yaxis!("Modularity")

plotC = scatter(foodweb_measures.modul, foodweb_measures.nested,
    markersize=foodweb_measures.rich ./ 30,
    alpha=0.6, color=pal.foodwebs,
    lab="",
    dpi=1000, framestyle=:box)
xaxis!("Modularity")
yaxis!((0.4,0.9), "Nestedness")

plot(plotA, plotB, plotC, layout=(1,3),
    title=["($i)" for j in 1:1, i in 1:3], titleloc=:right, titlefont = font(12),
    size=(700,350), margin=5Plots.mm)
```

![Association between (1) connectance and nestedness, (2) connectance and modularity, and (3) modularity and nestedness in food webs archived on `mangal.io`. We compute nestedness as the spectral radius of a network (i.e. the largest absolute eigenvalue of its matrix of interactions). We optimize network modularity using the BRIM algorithm (best partition out of 100 random runs for 3 to 15 modules). The marker size is proportional to the number of species in a network, which varies between 5 and 714 species.](fig/nestmod.png)

The script to reproduce these figures is available in the [GitHub repository](https://github.com/EcoJulia/EcologicalNetworks.jl/blob/joss-article/paper/main.jl). This example is taken from the manuscript describing `Mangal.jl` and `EcologicalNetworks.jl` submitted to the Journal of Open Source Software (JOSS).
