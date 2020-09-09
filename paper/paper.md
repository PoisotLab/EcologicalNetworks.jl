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
 - name: Deptartment of biology, Université de Montréal, Canada
   index: 1
 - name: Department of biology, Université de Sherbrooke, Canada
   index: 2
date: 14 September 2020
bibliography: paper.bib
---


# Summary
Network ecology is an emerging field of study describing species interactions (e.g. predation, pollination) in a biological community. Ecological networks, in which two species are connected if they can interact, are a mathematical representation of all interactions encountered in a given ecosystem. Anchored in graph theory, the methods developed in network ecology are remarkably rigorous and biologically insightful. Indeed, many ecological and evolutionary processes are driven by species interactions and network structure (i.e. the arrangement of links in ecological networks). The study of ecological networks, from data importation and simulation to data analysis and visualization, require a coherent and efficient set of numerical tools. With its powerful and dynamic type system, the Julia programming language provides a solid computing environment in this regard. `EcologicalNetworks.jl` is a novel Julia package designed to conduct these numerical analysis in an integrated environment for ecological research in Julia.

# Statement of need
Analyzing ecological networks is a challenging task. Several measures are commonly used to characterize the structure of ecological networks [@DelmBess19], and their implementation can sometimes be arduous or computationally expensive. The Julia programming language was designed for data science and machine learning, and can thus provide the algorithmic efficiency needed in network ecology. A few packages, such as `LightGraphs.jl` [@Bromberger17], have been written in Julia to analyze any type of graphs. However, the functions provided by these packages are often unsuited for ecological research. When misapplied, they can mislead ecologists in their interpretation of ecological phenomena.

`EcologicalNetworks.jl` [@PoisBeli19a] was specifically designed for network ecology. The most common measures used to analyze deterministic [@DelmBess19] and probabilistic networks [@PoisCirt16] can be readily and rapidly computed using our package. Moreover, we provided a set of functions to simulate ecological networks under null models (i.e. models without given processes), a common practice among ecologists to investigate the deviation of empirical measures from their expected values [see for example @BascJord03a; @FortBasc06; and @DelmBess19].


# Type system

`EcologicalNetworks.jl` is based upon a hierarchical type system which ensures that measures are applied to appropriate networks. In our package, ecological networks are represented by a matrix of pairwise interactions (the *adjacency* matrix), along with an array of species names and, when applicable, an array of interaction weights or probabilities.

The vast majority of networks of species interactions in fact fall into two broad categories: unipartite and bipartite networks. Pollination networks are a common example of bipartite networks where members of a set of species (pollinators) interact exclusively with members of a second set (plants). In contrast, food webs, for instance, are unipartite networks because species can not be clearly subdivided into such distinctive groups. Furthermore, ecological networks, whether they are unipartite or bipartite, can also be deterministic or probabilistic. In deterministic networks, pairwise interactions are of type Boolean when they represent the presence or absence of an interaction between two species; they are on the other hand quantitative when interaction strengths are encoded. In probabilistic networks, pairwise interactions are floating-point numbers that represent the probability that two species interact in a given environment.

These six types of networks are all represented in a hierarchical system of types in `EcologicalNetworks.jl`. This greatly facilitates the manipulation and analysis of all kinds of ecological networks. We invite the readers to take a look at @PoisBeli19a for a more complete discussion on our type system.


# EcoJulia

`EcologicalNetworks.jl` is part of [EcoJulia](https://ecojulia.github.io/), an integrated environment for the conduction of ecological research in Julia. When `EcologicalNetworks.jl` is used along with [`Mangal.jl`](https://github.com/EcoJulia/Mangal.jl) and [`EcologicalNetworksPlots.jl`](https://github.com/EcoJulia/EcologicalNetworksPlots.jl), these three packages can provide a valuable methodological framework for the analysis of ecological networks in Julia.

`Mangal.jl` is used to query data directly from the [`mangal.io`](https://mangal.io/#/) database. To this date, 172 datasets of a total of more than 1,300 ecological networks of various types are archived on `mangal.io`. This makes it one of the most extensive databases of ecological networks. Although based on a slightly different type system, this package is well integrated with `EcologicalNetworks.jl`, as illustrated in the next subsection.

`EcologicalNetworksPlots.jl`, on the other hand, is used to visualize all types of ecological networks. It uses the same type system as `EcologicalNetworks.jl`.



# Use case

Connectance (i.e. the proportion of all possible links that are realized) is undoubtedly one the most studied and important measure of ecological networks [@PoisGrav14]. A network's connectance is the result of many ecological processes, and predicts how a biological community functions and responds to changes [@DunnWill02c; @DunnWill02d]. Connectance is furthermore associated with other network measures, including nestedness and modularity [@DelmBess19]. A network is nested when species that interact with specialists (i.e. species with few interactions) are a subset of the species that interact with generalists (i.e. species with many interactions). On the other hand, a network is modular when species are organized in groups of highly interacting species. @FortStou10 showed how these two quantities were associated in ecological networks. Here we show how `EcologicalNetworks.jl` and `Mangal.jl` can be used to retrieve these associations in food webs.


We started by reading metadata of all networks archived on `mangal.io`. We stored their ID numbers, as well as their total numbers of species $S$, of interactions $L$, of interactions of predation $P$, and of interactions of herbivory $H$ in a data frame.

```julia

using Mangal
using DataFrames

number_of_networks = count(MangalNetwork)
count_per_page = 100
number_of_pages = convert(Int,
                      ceil(number_of_networks/count_per_page))

mangal_networks = DataFrame(fill(Int64, 5),
                      [:id, :S, :L, :P, :H], number_of_networks)

global cursor = 1
@progress "Paging networks" for page in 1:number_of_pages
    global cursor
    networks_in_page = Mangal.networks("count"=>count_per_page,
                                       "page"=>page-1)
    @progress "Counting items" for current_network
                               in networks_in_page
        S = count(MangalNode, current_network)
        L = count(MangalInteraction, current_network)
        P = count(MangalInteraction, current_network,
                  "type" => "predation")
        H = count(MangalInteraction, current_network,
                  "type" => "herbivory")
        mangal_networks[cursor,:] .=
              (current_network.id, S, L, P, H)
        cursor = cursor + 1
    end
end
```
To keep food webs only, we filtered for networks that contained at least one interaction of predation or of herbivory. We discarded the largest network for plotting reasons.

```julia

mangal_PH = mangal_networks[
                     (mangal_networks[:,:P] .> 0) .|
                     (mangal_networks[:,:H] .> 0), :]

mangal_PH_nolarge = mangal_PH[
                     mangal_PH[:S].!=maximum(mangal_PH[:S]),:]
```

We then used the food webs' ID numbers to import their actual data from `Mangal.jl`. At this point, the imported networks are of type `MangalNetwork`.

```julia

mangal_food_webs = network.(mangal_PH_nolarge.id)
```

We used `EcologicalNetworks.jl` to convert them to type `UnipartiteNetwork`, when possible (i.e. when they had sufficient and adequate data for conversion). Food-web measures are typically computed on objects of this type.

```julia
using EcologicalNetworks

food_webs=[]

for i in eachindex(mangal_food_webs)
    try
        unipartite_food_web = convert(UnipartiteNetwork,
                                      mangal_food_webs[i])
        push!(food_webs, unipartite_food_web)
    catch
        println("Cannot convert mangal food web $(i)
                to a unipartite network")
    end
end
```

Computing the richness (i.e. the number of species) and connectance was straightforward:

```julia

food_webs_richness = richness.(food_webs)
food_webs_connectance = connectance.(food_webs)
```

Nestedness can then be computed using the spectral radius $\rho$ of the matrix of interactions [i.e. its largest absolute eigenvalue, @StanKopp13].

```julia

food_webs_nestedness = rho.(food_webs)
```

To compute network modularity, we need a starting point, an optimizer and a measure of modularity [@Newm06; @Barb07; @Theb13]. We used 100 random assignments of the species in 3 to 15 groups as our starters. We chose the BRIM algorithm to optimize the modularity for each of these random starters. We then computed modularity following [@Newm06], and retained the maximum value for each of the food webs.

```julia

food_webs_modularity = []

number_of_modules = repeat(3:15, outer=100)
modules = Array{Dict}(undef, length(n))

for i in 1:length(food_webs)
    current_network = food_webs[i]
    for j in eachindex(number_of_modules)
        _, modules[j] = n_random_modules(number_of_modules[j])
                                        (current_network)
        |> x -> brim(x...)
    end
    partition_modularity = map(x -> Q(current_network,x),
                                      modules);
    push!(food_webs_modularity, maximum(partition_modularity))
end
```

The association between richness, connectance, nestedness and modularity in all food webs archived on `mangal.io` is plotted in \autoref{fig:nestmod}.

![In food webs archived on `mangal.io`, nestedness is negatively associated with modularity, but both nestedness and modularity are strongly associated with connectance. Nestedness was calculated as the spectral radius of a network (i.e. the largest absolute eigenvalues of its adjacency matrix). We optimized network modularity using the BRIM algorithm (best partition out of 100 random runs for 3 to 15 groups). Marker size is proportional to the total number of species in a network, which varied between 5 and 90 species. All measures were computed using `EcologicalNetworks.jl`.\label{fig:nestmod}](nestmod.png)

# Acknowledgements

We acknowledge contributions from Steve Vissault, Zachary Bélisle, Laura Hoebeke, Michiel Stock and Piotr Szefer for their help in the development of theses packages.

# References
