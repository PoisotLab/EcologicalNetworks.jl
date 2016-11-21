"""
Probability that a species has no predecessors
"""
function species_has_no_predecessors(N::Unipartite)
    return vec(prod(1.0 .- nodiag(N).A,1))
end

"""
Probability that a species has no successors
"""
function species_has_no_successors(N::Unipartite)
    return species_has_no_predecessors(N')
end

"""
Probability that a species has no links

This will return a vector, where the *i*th element is the probability that
species *i* has no interaction. Note that this is only meaningful for
unipartite networks.
"""
function species_is_free(N::Unipartite)
  return species_has_no_successors(N) .* species_has_no_predecessors(N)
end

"""
Expected number of species with no interactions

This function will be applied on the *unipartite* version of the network. Note
that the functions `species_ |predecessors` will work on bipartite networks,
but the unipartite situation is more general.
"""
function free_species(N::EcoNetwork)
    if typeof(N) <: Unipartite
        return N |> species_is_free |> sum
    else
        return N |> make_unipartite |> free_species
    end
end
