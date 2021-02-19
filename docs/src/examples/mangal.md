In this example, we will show how `EcologicalNetworks.jl` can be integrated with [`Mangal.jl`](https://github.com/EcoJulia/Mangal.jl) to analyse many ecological networks. Specifically, we will show how to analyse the association between meaningful network properties (i.e. connectance, nestedness, and modularity) using all food webs archived on the [`mangal.io`](https://mangal.io/#/) online database.

To conduct this analysis, we need to upload the following packages:

```@example mangal
using EcologicalNetworks
using Mangal
using DataFrames
using Plots
using Plots.PlotMeasures
```

We first retrieve relevant metadata for all 1,386 networks archived on `mangal.io` using the `Mangal.jl` package. We count the number of species $S$ and the total number of interactions $L$ in each network, as well as their number of trophic interactions (predation and herbivory). We store these information in a data frame along with the networks' ID numbers, and print the first 5 elements. Due to the high number of networks we handle, note that this step might take some time to run.

```@example mangal
number_of_networks = count(MangalNetwork)
count_per_page = 100
number_of_pages = convert(Int, ceil(number_of_networks/count_per_page))

mangal_networks = DataFrame(fill(Int64, 5),
                 [:id, :S, :L, :pred, :herb],
                 number_of_networks)

global cursor = 1
for page in 1:number_of_pages
    global cursor
    networks_in_page = Mangal.networks("count" => count_per_page, "page" => page-1)
    for current_network in networks_in_page
        S = count(MangalNode, current_network)
        L = count(MangalInteraction, current_network)
        pred = count(MangalInteraction, current_network, "type" => "predation")
        herb = count(MangalInteraction, current_network, "type" => "herbivory")
        mangal_networks[cursor,:] .= (current_network.id, S, L, pred, herb)
        cursor = cursor + 1
    end
end

first(mangal_networks, 5)
```

We now have all the information we need to identify all food webs archived on `mangal.io`. Here we consider as food webs any ecological networks mainly composed of trophic interactions. We find that 259 networks meet this condition.  

```@example mangal
foodwebs = mangal_networks[mangal_networks[!, :pred] .+ mangal_networks[!, :herb] ./ mangal_networks[!, :L] .> 0.5, :]

first(foodwebs, 5)
```

To analyse their properties, we first need to read all of these food webs using the `Mangal.jl` package, and then convert them to UnipartiteNetworks using the `EcologicalNetworks.jl` package. 

```@example mangal
mangal_foodwebs = network.(foodwebs.id)

unipartite_foodwebs = convert.(UnipartiteNetwork, mangal_foodwebs)

unipartite_foodwebs[1:5]
```

We can then compute any measure supported by `EcologicalNetworks.jl` for UnipartiteNetworks. In this example, we compute connectance, nestedness, and modularity. To compute network modularity, we use 100 random species assignments in 3 to 15 groups as our starters, the BRIM algorithm to optimize the modularity for each of these random partitions, and retain the maximum value for each food web. Readers are invited to take a look at the [documentation](https://ecojulia.github.io/EcologicalNetworks.jl/dev/properties/modularity/) for further details on how to compute modularity.

```@example mangal
foodweb_measures = DataFrame(fill(Float64, 3),
                 [:connect, :nested, :modul],
                 length(unipartite_foodwebs))

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

first(foodweb_measures, 5)
```

The association between these food-web measures can then be plotted. We find that modularity is negatively associated with connectance and nestedness, whereas nestesdness and connectance are positively associated.

```@example mangal
pal=RGB(204/255,121/255,167/255)

scatter(foodweb_measures.connect, foodweb_measures.nested,
    alpha=0.6, color=pal,
    lab="", framestyle=:box,
    xlabel="Connectance",
    ylabel="Nestedness",
    margin = 10mm)
```

```@example mangal
scatter(foodweb_measures.connect, foodweb_measures.modul,
    alpha=0.6, color=pal,
    lab="",framestyle=:box,
    xlabel="Connectance",
    ylabel="Modularity",
    margin = 10mm)
```

```@example mangal
scatter(foodweb_measures.modul, foodweb_measures.nested,
    alpha=0.6, color=pal,
    lab="", framestyle=:box,
    xlabel="Modularity",
    ylabel="Nestedness",
    margin = 10mm)
```
