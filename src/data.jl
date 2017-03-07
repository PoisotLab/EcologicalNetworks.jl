"""
Stony food web from Thompson & Townsend. This was sampled in a tussock grassland
near Otago, New Zealand. Note that there is, in the original matrix, a species
with no interactions. It is removed when generating the network.
"""
function stony()
    n_path = joinpath(Pkg.dir("EcologicalNetwork"), "data", "du_stony.txt")
    N = UnipartiteNetwork(readdlm(n_path))
    # remove species without interactions
    have_deg = degree(N) .> 0
    keep_sp = filter(x -> have_deg[x], 1:richness(N))
    # return
    return UnipartiteNetwork(N[keep_sp, keep_sp])
end

"""
Plant-flower visitor interactions in the Galapagos.
"""
function mcmullen()
    n_path = joinpath(Pkg.dir("EcologicalNetwork"), "data", "db_mcmullen.txt")
    return BipartiteNetwork(readdlm(n_path))
end

"""
Fish-anemone interactions from Ollerton et al. 2007
"""
function ollerton()
    n_path = joinpath(Pkg.dir("EcologicalNetwork"), "data", "db_ollerton.txt")
    return BipartiteNetwork(readdlm(n_path))
end

"""
Pollination interaction from Robertson 1927, in an agricultural area dominated
by crops, with some natural forest and pasture.
"""
function robertson()
    n_path = joinpath(Pkg.dir("EcologicalNetwork"), "data", "db_robertson.txt")
    return BipartiteNetwork(readdlm(n_path))
end

"""
Number of visits from Bluthgen et al XXX
"""
function bluthgen()
    n_path = joinpath(Pkg.dir("EcologicalNetwork"), "data", "qb_bluthgen.txt")
    return BipartiteQuantiNetwork(readdlm(n_path))
end

"""
Lake of the Woods host-parasite data. Interactions content are prevalence.
"""
function woods()
    n_path = joinpath(Pkg.dir("EcologicalNetwork"), "data", "qb_woods.txt")
    # This matrix is in the wrong format on IWDB
    return BipartiteQuantiNetwork(readdlm(n_path)')
end

"""
Soil-isolated phage-bacteria networks. Interactions are the impact of phage on
the bacteria.

<https://figshare.com/articles/Phage_bacteria_networks_isolated_in_soil/696102>

Takes a positional argument `i`, indicating which network (from 1 to 5) to
return.
"""
function soilphagebacteria(i::Int64=1)
  @assert i ∈ [1:5]
  n_path = joinpath(Pkg.dir("EcologicalNetwork"), "data", "qb_soilphagebacteria_", string(i), ".txt")
  return BipartiteQuantiNetwork(readdlm(n_path))
end
