## use-case for the paper submitted to JOSS

# upload packages
using EcologicalNetworks
using Mangal
using DataFrames
using Plots

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
        _, modules[j] = n_random_modules(number_of_modules[j])(current_network) |> x -> brim(x...)
    end
    partition_modularity = map(x -> Q(current_network,x), modules);
    push!(food_webs_modularity, maximum(partition_modularity))
end


# plot: association between connectance, nestedness and modularity (marker size=richness)
plotA = scatter(food_webs_connectance, food_webs_nestedness,
    markersize=food_webs_richness ./ 10,
    alpha=0.6, color=RGB(0/255,158/255,115/255),
    lab="",
    dpi=1000, framestyle=:box)
xaxis!("Connectance")
yaxis!((0.4,0.9), "Nestedness")

plotB = scatter(food_webs_connectance, food_webs_modularity,
    markersize=food_webs_richness ./ 10,
    alpha=0.6, color=RGB(0/255,158/255,115/255),
    lab="",
    dpi=1000, framestyle=:box)
xaxis!("Connectance")
yaxis!("Modularity")

plotC = scatter(food_webs_modularity, food_webs_nestedness,
    markersize=food_webs_richness ./ 10,
    alpha=0.6, color=RGB(0/255,158/255,115/255),
    lab="",
    dpi=1000, framestyle=:box)
xaxis!("Modularity")
yaxis!((0.4,0.9), "Nestedness")

plot(plotA, plotB, plotC, layout=(1,3),
    title=["($i)" for j in 1:1, i in 1:3], titleloc=:right, titlefont = font(12),
    size=(700,350), margin=5Plots.mm)
savefig("paper/nestmod.png")
