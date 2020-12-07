## Use case for the paper submitted to JOSS
# We create two plots using Mangal.jl and EcologicalNetworks.jl
# First plot: association between the number of species and the number of links in different types of networks
# Second plot: association between richness, connectance, nestedness, and modularity in food webs


## upload packages
using EcologicalNetworks
using Mangal
using DataFrames
using Plots


## read data from mangal.io

# read the id and other metadata of all ecological networks archived on mangal.io
# id: network ID
# S: number of species in the network
# L: number of interactions in the network
# pred: number of interactions of predation in the network
# herb: number of interactions of herbivory in the network
# mutu: number of interactions of mutualism in the network
# para: number of interactions of parasitism in the network

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


## classify all networks according to their most frequent type of interactions

# number of interactions in food webs (sum of predation and herbivory interactions)
mangal_networks.foodweb = mangal_networks.pred .+ mangal_networks.herb

# number of other types of interactions
mangal_networks.other = mangal_networks.L .- mangal_networks.foodweb .- mangal_networks.mutu .- mangal_networks.para

# remove networks with less than 5 links
mangal_networks2 = mangal_networks[mangal_networks.L .> 4, :]

# classify network according to their most frequent type of interactions
number_interactions_max_type = maximum.(eachrow(mangal_networks2[:,[:mutu, :para,:foodweb,:other]]))

foodwebs = mangal_networks2[mangal_networks2[!, :foodweb] .== number_interactions_max_type ,:]
parasitism_webs = mangal_networks2[mangal_networks2[!, :para] .== number_interactions_max_type ,:]
mutualism_webs = mangal_networks2[mangal_networks2[!, :mutu] .== number_interactions_max_type ,:]
other_webs = mangal_networks2[mangal_networks2[!, :other] .== number_interactions_max_type ,:]



## read food webs from mangal.io and convert them to unipartie networks using EcologicalNetworks.jl

# read all food webs archived on mangal.io
mangal_foodwebs = network.(foodwebs.id)

# convert MangalNetworks to UnipartiteNetworks when possible
unipartite_foodwebs = convert.(UnipartiteNetwork, mangal_foodwebs)


## compute food-web measures (i.e. richness, connectance, nestedness and modularity)

foodweb_measures = DataFrame(fill(Float64, 4),
                 [:rich, :connect, :nested, :modul],
                 length(unipartite_foodwebs))

# compute richness and connectance
foodweb_measures.rich = richness.(unipartite_foodwebs)
foodweb_measures.connect = connectance.(unipartite_foodwebs)

# compute nestedness (spectral radius of the adjacency matrix)
foodweb_measures.nested = ρ.(unipartite_foodwebs)

# compute modularity (BRIM algorithm)
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



## plot 1: association between the number of species and the number of links in different types of networks

# color palette
pal = (
    foodwebs=RGB(204/255,121/255,167/255),
    parasitism=RGB(230/255,159/255,0/255),
    mutualism=RGB(0/255,158/255,115/255),
    other=RGB(86/255,190/255,233/255),
    )


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
savefig("paper/fig/LS.png")




## plot 2: association between richness, connectance, nestedness, and modularity in food webs

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
savefig("paper/fig/nestmod.png")
