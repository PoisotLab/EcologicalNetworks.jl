"""
Stony food web from Thompson & Townsend

Taken from `https://www.nceas.ucsb.edu/interactionweb/html/thomps_towns.html`
"""
function stony()
    return UnipartiteNetwork(readdlm("data/du_stony.txt"))
end

"""
Plant-flower visitor interactions in the Galapagos.

Taken from `https://www.nceas.ucsb.edu/interactionweb/html/mc_mullen.html`
"""
function mcmullen()
    return BipartiteNetwork(readdlm("data/db_mcmullen.txt"))
end

