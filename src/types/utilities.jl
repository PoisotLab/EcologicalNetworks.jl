using Base

"""
**Interaction between two species**

    has_interaction(N::AbstractEcologicalNetwork, i::Int64, j::Int64)

This function returns `true` if the interaction between `i` and `j` is not 0.
This is used internally by a few function, but is exported because it may be of
general use.
"""
function has_interaction(N::AbstractEcologicalNetwork, i::Int64, j::Int64)
  # We need to make sure that the interaction is somewhere within the network
  @assert i <= size(N.A, 1)
  @assert j <= size(N.A, 2)
  # This should be reasonably general...
  return N[i,j] > zero(typeof(N[i,j]))
end

function has_interaction{NT<:Union{AbstractString,Symbol}}(N::AbstractBipartiteNetwork, i::NT, j::NT)
  # We need to make sure that the interaction is somewhere within the network
  @assert i ∈ N.T
  @assert j ∈ N.B
  i_pos = first(find(i.==N.T))
  j_pos = first(find(j.==N.B))
  return has_interaction(N, i_pos, j_pos)
end

function has_interaction{NT<:Union{AbstractString,Symbol}}(N::AbstractUnipartiteNetwork, i::NT, j::NT)
  # We need to make sure that the interaction is somewhere within the network
  @assert i ∈ N.S
  @assert j ∈ N.S
  i_pos = first(find(i.==N.S))
  j_pos = first(find(j.==N.S))
  return has_interaction(N, i_pos, j_pos)
end

"""
Return the size of the adjacency matrix of an AbstractEcologicalNetwork object.
"""
function Base.size(N::AbstractEcologicalNetwork)
    Base.size(N.A)
end

"""
Creates a copy of a network -- this returns an object with the same type, and
the same content.
"""
function Base.copy(N::AbstractBipartiteNetwork)
  a = copy(N.A)
  t = copy(N.T)
  b = copy(N.B)
  return typeof(N)(a, t, b)
end

function Base.copy(N::AbstractUnipartiteNetwork)
  a = copy(N.A)
  s = copy(N.S)
  return typeof(N)(a, s)
end

"""
Return a transposed network with the correct type
"""
function Base.transpose(N::AbstractEcologicalNetwork)
    return typeof(N)(transpose(N.A))
end

"""
Getindex custom to get interaction value from an AbstractEcologicalNetwork
"""
function Base.getindex(N::AbstractEcologicalNetwork, i...)
  return getindex(N.A, i...)
end

"""
Setindex for AbstractEcologicalNetwork
"""
function Base.setindex!(N::AbstractEcologicalNetwork, i...)
  return setindex!(N.A, i...)
end

function nrows(N::AbstractEcologicalNetwork)
  return size(N.A, 1)
end

function ncols(N::AbstractEcologicalNetwork)
  return size(N.A, 2)
end

"""
Richness (number of species) in a bipartite network
"""
function richness(N::AbstractBipartiteNetwork)
  return sum(size(N.A))
end

"""
Richness (number of species) in a unipartite network
"""
function richness(N::AbstractUnipartiteNetwork)
    return size(N.A, 1)
end
