"""
**Read a network from a CSV file**

  read_network_from_csv{T<:AbstractEcologicalNetwork}(f, t::T)


Will read a network from a CSV file, and return it as a correctly formated network.
"""
function read_network_from_csv{T<:AbstractEcologicalNetwork}(f, t::T)

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
