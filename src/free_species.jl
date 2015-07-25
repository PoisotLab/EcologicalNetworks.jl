""" Probability that a species has no predecessors """
function species_has_no_predecessors(A::Array{Float64,2})
  @assert size(A)[1] == size(A)[2]
  return vec(prod(1.0 .- nodiag(A),1))
end

""" Probability that a species has no successors """
function species_has_no_successors(A::Array{Float64,2})
  @assert size(A)[1] == size(A)[2]
  return vec(prod(1.0 .- nodiag(A),2))
end

""" Probability that a species has no links

This will return a vector, where the *i*th element is the probability that
species *i* has no interaction. Note that this is only meaningful for unipartite
networks.

"""
function species_is_free(A::Array{Float64,2})
  @assert size(A)[1] == size(A)[2]
  return species_has_no_successors(A) .* species_has_no_predecessors(A)
end

""" Expected number of species with no interactions

This function will be applied on the *unipartite* version of the network. Note
that the functions `species_ |predecessors` will work on bipartite networks, but
the unipartite situation is more general.

"""
function free_species(A::Array{Float64,2})
  if length(unique(size(A))) == 1
    return A |> species_is_free |> sum
  end
  return A |> make_unipartite |> species_is_free |> sum
end
