---
title: 'EcologicalNetworks.jl: A Julia package for analyzing networks of species interactions'
tags:
  - Julia
  - ecological networks
  - food webs
  - species interactions
  - graph theory

authors:
  - name: Francis Banville^[corresponding author]
    orcid: 0000-0001-9051-0597
    affiliation: "1, 2" # (Multiple affiliations must be quoted)
  - name: Timothée Poisot
    orcid: 0000-0002-0735-5184
    affiliation: 1
affiliations:
 - name: Dept of biology, Université de Montréal, Canada
   index: 1
 - name: Dept of biology, Université de Sherbrooke, Canada
   index: 2
date: 14 September 2020
bibliography: paper.bib
---


# Summary
Network ecology is an emerging field of study describing species interactions (e.g. predation, pollination) in a biological community. Ecological networks, in which two species are connected if they can interact, are a mathematical representation of all interactions encountered in a given ecosystem. Anchored in graph theory, the methods developed in network ecology are remarkably rigorous and biologically insightful. Indeed, many ecological and evolutionary processes are driven by species interactions and network structure (i.e. the arrangement of links in ecological networks). The study of ecological networks, from data importation and simulation to data analysis and visualization, require a coherent and efficient set of numerical tools. With its powerful and dynamic type system, the Julia programming language provides a solid computing environment in this regard. `EcologicalNetworks.jl` is a novel Julia package designed to conduct these numerical analysis in an integrated environment for ecological research in Julia.

# Statement of need
Analyzing ecological networks is a challenging task. Several measures are commonly used to characterize the structure of ecological networks, and their implementation can sometimes be arduous. Further, different methods are used for different types of networks. `EcologicalNetworks.jl` aims to overcome these challenges.

# Type system
Ecological networks are of various types, and the analysis of each of these types requires slightly different numerical methods. The vast majority of networks of species interactions in fact fall into two broad categories: unipartite and bipartite networks. Pollination networks are a common example of bipartite networks where members of a set of species (pollinators) interact exclusively with members of a second set (plants). In contrast, food webs, for instance, are unipartite networks because species can not be clearly subdivided into two distinctive groups. Furthermore, ecological networks, whether they are unipartite or bipartite, can also be deterministic or probabilistic. In deterministic networks, pairwise interactions are binary when they represent the presence or absence of an interaction between two species; they are on the other hand quantitative when interaction strengths are encoded. In probabilistic networks, pairwise interactions represent the probability that two species interact in a given environment. These types of networks are all represented in a hierarchical system of types in `EcologicalNetworks.jl`. This greatly facilitates their manipulation and analysis.

# Simulation and analysis


# Integrated environment
`Mangal.jl`
`EcologicalNetworksPlots.jl`

# Illustration

```julia
using Mangal
using DataFrames

# read the id and other metadata of all ecological networks archived on Mangal.io
# id: network id
# S: number of species in the network
# L: number of interactions in the network
# P: number of interactions of predation in the network
# H: number of interactions of herbivory in the network

number_of_networks = count(MangalNetwork)
count_per_page = 100
number_of_pages = convert(Int, ceil(number_of_networks/count_per_page))

mangal_networks = DataFrame(fill(Int64, 5), [:id, :S, :L, :P, :H], number_of_networks)

global cursor = 1
@progress "Paging networks" for page in 1:number_of_pages
    global cursor
    networks_in_page = Mangal.networks("count" => count_per_page, "page" => page-1)
    @progress "Counting items" for current_network in networks_in_page
        S = count(MangalNode, current_network)
        L = count(MangalInteraction, current_network)
        P = count(MangalInteraction, current_network, "type" => "predation")
        H = count(MangalInteraction, current_network, "type" => "herbivory")
        mangal_networks[cursor,:] .= (current_network.id, S, L, P, H)
        cursor = cursor + 1
    end
end
```

```julia
using EcologicalNetworks

# filter for food webs (i.e. ecological networks with at least 1 interaction of predation or herbivory)
mangal_PH = mangal_networks[(mangal_networks[:,:P] .> 0) .| (mangal_networks[:,:H] .> 0), :]

# discard the biggest food web to make the plot more comprehensible
mangal_PH_nolarge = mangal_PH[mangal_PH[:S].!=maximum(mangal_PH[:S]),:]

# read all food webs archived on mangal.io
mangal_food_webs = network.(mangal_PH_nolarge.id)

# convert MangalNetworks to UnipartiteNetworks when possible
food_webs=[]

for i in 1:length(mangal_food_webs)
    try
        unipartite_food_web = convert(UnipartiteNetwork, mangal_food_webs[i])
        push!(food_webs, unipartite_food_web)
    catch
        println("Cannot convert mangal food web $(i) to a unipartite network")
    end
end
```

```julia

# compute richness and connectance of all food webs
food_webs_richness = richness.(food_webs)
food_webs_connectance = connectance.(food_webs)

# compute nestedness of all food webs
food_webs_nestedness = ρ.(food_webs)

# compute modularity of all food webs
food_webs_modularity = []

number_of_modules = repeat(3:15, outer=100)
modules = Array{Dict}(undef, length(n))

for i in 1:length(food_webs)
    current_network = food_webs[i]
    for j in eachindex(number_of_modules)
        _, modules[j] = n_random_modules(number_of_modules[j])(current_network)
        |> x -> brim(x...)
    end
    partition_modularity = map(x -> Q(current_network,x), modules);
    push!(food_webs_modularity, maximum(partition_modularity))
end
```

![In food webs, nestedness is negatively associated with modularity, but both nestedness and modularity are strongly associated with connectance. Nestedness was calculated as the spectral radius of a network (i.e. the largest absolute eigenvalues of its adjacency matrix). We optimized network modularity using the BRIM algorithm (best partition out of 100 random runs for 3 to 15 modules).  Marker size is proportional to the total number of species in a network, which varied between 5 and 90 species.](nestmod.png)

# Acknowledgements

We acknowledge contributions from Steve Vissault, Zachary Bélisle, Laura Hoebeke, Michiel Stock and Piotr Szefer for their help in the development of theses packages.

# References
