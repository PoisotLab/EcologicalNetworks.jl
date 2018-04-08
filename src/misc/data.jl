function read_network_from_csv(f, t)
  
end

"""
**Kyoto University Forest of Ashu pollination network**

    kato()

Interaction strength is the mumber of plant visits by insects.

<https://www.nceas.ucsb.edu/interactionweb/html/kato_1990.html>
"""
function kato()
  n_path = joinpath(@__DIR__, "..", "data", "qb_kato.txt")
  N = BipartiteQuantiNetwork(readdlm(n_path))
  return N
end
