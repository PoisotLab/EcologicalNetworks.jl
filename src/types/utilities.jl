using Base

function species(N::AbstractUnipartiteNetwork)
  return N.S
end

function species(N::AbstractBipartiteNetwork)
  return vcat(N.T, N.B)
end

function species(N::AbstractBipartiteNetwork, i::Int64)
  @assert i ∈ [1,2]
  return i == 1 ? N.T : N.B
end

function species(N::AbstractUnipartiteNetwork, i::Int64)
  @assert i ∈ [1,2]
  return N.S
end

function species_objects(N::AbstractUnipartiteNetwork)
  return (N.S,)
end

function species_objects(N::AbstractBipartiteNetwork)
  return (N.T, N.B)
end

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

function has_interaction{NT<:AllowedSpeciesTypes}(N::AbstractEcologicalNetwork, i::NT, j::NT)
  @assert i ∈ species(N, 1)
  @assert j ∈ species(N, 2)
  i_pos = first(find(i.==species(N,1)))
  j_pos = first(find(j.==species(N,2)))
  return has_interaction(N, i_pos, j_pos)
end

function nodiagonal(N::AbstractUnipartiteNetwork)
  x = N.A
  for i in 1:size(x,1)
    x[i,i] = zero(eltype(x))
  end
  return typeof(N)(x, N.S)
end

function nodiagonal(N::AbstractBipartiteNetwork)
  return copy(N)
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
function Base.copy(N::AbstractEcologicalNetwork)
  a = copy(N.A)
  sp = copy.(species_objects(N))
  return typeof(N)(a, sp...)
end

"""
Getindex custom to get interaction value from an AbstractEcologicalNetwork
"""
function Base.getindex(N::AbstractEcologicalNetwork, i...)
  return getindex(N.A, i...)
end

function Base.getindex{T<:AllowedSpeciesTypes}(N::AbstractEcologicalNetwork, s1::T, s2::T)
  @assert s1  ∈ species(N, 1)
  @assert s2  ∈ species(N, 2)
  s1_pos = first(find(s1.==species(N,1)))
  s2_pos = first(find(s2.==species(N,2)))
  return N[s1_pos, s2_pos]
end

function Base.getindex{T<:AllowedSpeciesTypes}(N::AbstractUnipartiteNetwork, sp::Array{T})
  @assert all(map(x -> x ∈ species(N), sp))
  sp_pos = map(s -> first(find(s.==species(N))), sp)
  n_sp = species(N)[sp_pos]
  n_int = N.A[sp_pos, sp_pos]
  return typeof(N)(n_int, n_sp)
end

function Base.getindex{T<:AllowedSpeciesTypes}(N::AbstractBipartiteNetwork, ::Colon, sp::Array{T})
  @assert all(map(x -> x ∈ species(N,2), sp))
  sp_pos = map(s -> first(find(s.==species(N,2))), sp)
  n_t = N.T
  n_b = N.B[sp_pos]
  n_int = N.A[:, sp_pos]
  return typeof(N)(n_int, n_t, n_b)
end

function Base.getindex{T<:AllowedSpeciesTypes}(N::AbstractBipartiteNetwork, sp::Array{T}, ::Colon)
  @assert all(map(x -> x ∈ species(N,1), sp))
  sp_pos = map(s -> first(find(s.==species(N,1))), sp)
  n_t = N.T[sp_pos]
  n_b = N.B
  n_int = N.A[sp_pos,:]
  return typeof(N)(n_int, n_t, n_b)
end

function Base.getindex{T<:AllowedSpeciesTypes}(N::AbstractBipartiteNetwork, sp1::Array{T}, sp2::Array{T})
  @assert all(map(x -> x ∈ species(N,1), sp1))
  @assert all(map(x -> x ∈ species(N,2), sp2))
  sp1_pos = map(s -> first(find(s.==species(N,1))), sp1)
  sp2_pos = map(s -> first(find(s.==species(N,2))), sp2)
  n_t = N.T[sp1_pos]
  n_b = N.B[sp2_pos]
  n_int = N.A[sp1_pos,sp2_pos]
  return typeof(N)(n_int, n_t, n_b)
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
function richness(N::AbstractEcologicalNetwork)
  return length(species(N))
end
