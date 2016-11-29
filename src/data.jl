"""
Stony food web from Thompson & Townsend. This was sampled in a tussock
grassland near Otago, New Zealand.
"""
function stony()
    n_path = joinpath(Pkg.dir("EcologicalNetwork"), "data", "du_stony.txt")
    return UnipartiteNetwork(readdlm(n_path))
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
