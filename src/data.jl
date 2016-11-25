"""
Stony food web from Thompson & Townsend

Taken from `https://www.nceas.ucsb.edu/interactionweb/html/thomps_towns.html`
"""
function stony()
    n_path = joinpath(Pkg.dir("EcologicalNetwork"), "data", "du_stony.txt")
    return UnipartiteNetwork(readdlm(n_path))
end

"""
Plant-flower visitor interactions in the Galapagos.

Taken from `https://www.nceas.ucsb.edu/interactionweb/html/mc_mullen.html`
"""
function mcmullen()
    n_path = joinpath(Pkg.dir("EcologicalNetwork"), "data", "db_mcmullen.txt")
    return BipartiteNetwork(readdlm(n_path))
end

