import Base.getindex
import Base.transpose
import Base.size
import Base.copy
import Base.:<
import Base.:<=
import Base.:>
import Base.:>=



"""
    species(N::AbstractUnipartiteNetwork)

Returns an array of all species in a unipartite network. The order of the
species corresponds to the order of rows/columns in the adjacency matrix.
"""
function species(N::AbstractUnipartiteNetwork)
  return N.S
end


"""
    species(N::AbstractBipartiteNetwork)

Returns an array of all species in a bipartite network. The order of the species
corresponds to the order of rows (top level) and columns (bottom level) of the
adjacency matrix, in this order.
"""
function species(N::AbstractBipartiteNetwork)
  return vcat(N.T, N.B)
end


"""
    species(N::AbstractBipartiteNetwork, i::Int64)

Returns an array of species in either side of a bipartite network. The `i`
parameter is the "margin" of the network, where `1` is species from the top, and
`2` is species from the bottom layer.
"""
function species(N::AbstractBipartiteNetwork, i::Int64)
  @assert i ∈ [1,2]
  return i == 1 ? N.T : N.B
end

"""
    species(N::AbstractUnipartiteNetwork, i::Int64)

Returns an array of species on either side of a unipartite network. In a
unipartite network, species are the same on either size, so this essentially
calls `species(N)`. This function is nevertheless useful when you want to write
code that takes either side of the network in a general way.
"""
function species(N::AbstractUnipartiteNetwork, i::Int64)
  @assert i ∈ [1,2]
  return species(N)
end

function species_objects(N::AbstractUnipartiteNetwork)
  return (N.S,)
end

function species_objects(N::AbstractBipartiteNetwork)
  return (N.T, N.B)
end


"""
    has_interaction(N::AbstractEcologicalNetwork, i::Int64, j::Int64)

This function returns `true` if the interaction between `i` and `j` is not 0.
This refers to species by their position instead of their name, and is not
recommended as the main solution. This is used internally by a few functions,
but is exported because it may be of general use.
"""
function has_interaction(N::AbstractEcologicalNetwork, i::Int64, j::Int64)
  # We need to make sure that the interaction is somewhere within the network
  @assert i <= size(N.A, 1)
  @assert j <= size(N.A, 2)
  # This should be reasonably general...
  return N[i,j] > zero(typeof(N[i,j]))
end


"""
    has_interaction{NT<:AllowedSpeciesTypes}(N::AbstractEcologicalNetwork, i::NT, j::NT)

This function returns `true` if the interaction between `i` and `j` is not 0.
This refers to species by their names/values, and is the recommended way to test
for the presence of an interaction.

Use `N[i,j]` if you need to get the value of the interaction.
"""
function has_interaction{NT<:AllowedSpeciesTypes}(N::AbstractEcologicalNetwork, i::NT, j::NT)
  @assert i ∈ species(N, 1)
  @assert j ∈ species(N, 2)
  i_pos = first(find(i.==species(N,1)))
  j_pos = first(find(j.==species(N,2)))
  return has_interaction(N, i_pos, j_pos)
end


"""
    nodiagonal(N::AbstractUnipartiteNetwork)

Returns a *copy* of the network with its diagonal set the appropriate zero.
"""
function nodiagonal(N::AbstractUnipartiteNetwork)
  x = N.A
  for i in 1:size(x,1)
    x[i,i] = zero(eltype(x))
  end
  return typeof(N)(x, N.S)
end

"""
    nodiagonal(N::AbstractBipartiteNetwork)

Returns a *copy* of the network (because the diagonal of a bipartite network is
never a meaningful notion). This function is clearly useless, but allows to
write general code for all networks types when a step requires removing the
diagonal.
"""
function nodiagonal(N::AbstractBipartiteNetwork)
  return copy(N)
end

"""
    size(N::AbstractEcologicalNetwork)

Return the size of the adjacency matrix of an `AbstractEcologicalNetwork` object.
"""
function size(N::AbstractEcologicalNetwork)
  size(N.A)
end

"""
Creates a copy of a network -- this returns an object with the same type, and
the same content.
"""
function copy(N::AbstractEcologicalNetwork)
  a = copy(N.A)
  sp = copy.(species_objects(N))
  return typeof(N)(a, sp...)
end

"""
    getindex(N::AbstractEcologicalNetwork, i...)

Uses positions to get an index from a network position. It is recommended *not*
to use this function, and instead use the variants of `getindex` working with
species names directly.
"""
function getindex(N::AbstractEcologicalNetwork, i...)
  return getindex(N.A, i...)
end

"""
    getindex{T<:AllowedSpeciesTypes}(N::AbstractEcologicalNetwork, s1::T, s2::T)

Get the value of an interaction based on the *name* of the species. This is the
recommended way to look for things in a network.
"""
function getindex{T<:AllowedSpeciesTypes}(N::AbstractEcologicalNetwork, s1::T, s2::T)
  @assert s1  ∈ species(N, 1)
  @assert s2  ∈ species(N, 2)
  s1_pos = first(find(s1.==species(N,1)))
  s2_pos = first(find(s2.==species(N,2)))
  return N[s1_pos, s2_pos]
end

"""
    getindex{T<:AllowedSpeciesTypes}(N::AbstractBipartiteNetwork, ::Colon, sp::T)

Gets the predecessors (*i.e.* species that interacts with / consume) of a focal
species. This returns the list of species as a `Set` object, in which ordering
is unimportant.
"""
function getindex{T<:AllowedSpeciesTypes}(N::AbstractEcologicalNetwork, ::Colon, sp::T)
  @assert sp ∈ species(N,2)
  return Set(filter(x -> has_interaction(N, x, sp), species(N,1)))
end

"""
    getindex{T<:AllowedSpeciesTypes}(N::AbstractEcologicalNetwork, sp::T, ::Colon)

Gets the successors (*i.e.* species that are interacted with / consumed) of a
focal species. This returns the list of species as a `Set` object, in which
ordering is unimportant.
"""
function getindex{T<:AllowedSpeciesTypes}(N::AbstractEcologicalNetwork, sp::T, ::Colon)
  @assert sp ∈ species(N,1)
  return Set(filter(x -> has_interaction(N, sp, x), species(N,2)))
end

"""
    getindex{T<:AllowedSpeciesTypes}(N::AbstractUnipartiteNetwork, sp::Array{T})

Induce a unipartite network based on a list of species, all of which must be in
the original network. This function takes a single argument (as opposed to two
arrays, or an array and a colon) to ensure that the returned network is
unipartite.
"""
function getindex{T<:AllowedSpeciesTypes}(N::AbstractUnipartiteNetwork, sp::Array{T})
  @assert all(map(x -> x ∈ species(N), sp))
  sp_pos = map(s -> first(find(s.==species(N))), sp)
  n_sp = species(N)[sp_pos]
  n_int = N.A[sp_pos, sp_pos]
  return typeof(N)(n_int, n_sp)
end

"""
    getindex{T<:AllowedSpeciesTypes}(N::AbstractBipartiteNetwork, ::Colon, sp::Array{T})

TODO
"""
function getindex{T<:AllowedSpeciesTypes}(N::AbstractBipartiteNetwork, ::Colon, sp::Array{T})
  @assert all(map(x -> x ∈ species(N,2), sp))
  sp_pos = map(s -> first(find(s.==species(N,2))), sp)
  n_t = N.T
  n_b = N.B[sp_pos]
  n_int = N.A[:, sp_pos]
  return typeof(N)(n_int, n_t, n_b)
end

"""
    getindex{T<:AllowedSpeciesTypes}(N::AbstractBipartiteNetwork, sp::Array{T}, ::Colon)

TODO
"""
function getindex{T<:AllowedSpeciesTypes}(N::AbstractBipartiteNetwork, sp::Array{T}, ::Colon)
  @assert all(map(x -> x ∈ species(N,1), sp))
  sp_pos = map(s -> first(find(s.==species(N,1))), sp)
  n_t = N.T[sp_pos]
  n_b = N.B
  n_int = N.A[sp_pos,:]
  return typeof(N)(n_int, n_t, n_b)
end

"""
    getindex{T<:AllowedSpeciesTypes}(N::AbstractBipartiteNetwork, sp1::Array{T}, sp2::Array{T})

TODO
"""
function getindex{T<:AllowedSpeciesTypes}(N::AbstractBipartiteNetwork, sp1::Array{T}, sp2::Array{T})
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
  warn("nrows is deprecated, use richness(N,1) instead")
  return size(N.A, 1)
end

function ncols(N::AbstractEcologicalNetwork)
  warn("ncols is deprecated, use richness(N,2) instead")
  return size(N.A, 2)
end

"""
    richness(N::AbstractEcologicalNetwork)

Returns the number of species in a network.
"""
function richness(N::AbstractEcologicalNetwork)
  return length(species(N))
end

"""
    richness(N::AbstractEcologicalNetwork, i::Int64)

Returns the number of species on either side of the network. The value of `i`
can be `1` (top-level species) or `2` (bottom-level species), as in the
`species` function.
"""
function richness(N::AbstractEcologicalNetwork, i::Int64)
  return length(species(N,i))
end

function :<{T<:Number,NT<:Union{QuantitativeNetwork,ProbabilisticNetwork}}(N::NT, n::T)
  newtype = typeof(N) <: AbstractBipartiteNetwork ? BipartiteNetwork : UnipartiteNetwork
  return newtype(N.A.<n, species_objects(N)...)
end

function :<={T<:Number,NT<:Union{QuantitativeNetwork,ProbabilisticNetwork}}(N::NT, n::T)
  newtype = typeof(N) <: AbstractBipartiteNetwork ? BipartiteNetwork : UnipartiteNetwork
  return newtype(N.A.<=n, species_objects(N)...)
end

function :>{T<:Number,NT<:Union{QuantitativeNetwork,ProbabilisticNetwork}}(N::NT, n::T)
  newtype = typeof(N) <: AbstractBipartiteNetwork ? BipartiteNetwork : UnipartiteNetwork
  return newtype(N.A.>n, species_objects(N)...)
end

function :>={T<:Number,NT<:Union{QuantitativeNetwork,ProbabilisticNetwork}}(N::NT, n::T)
  newtype = typeof(N) <: AbstractBipartiteNetwork ? BipartiteNetwork : UnipartiteNetwork
  return newtype(N.A.>=n, species_objects(N)...)
end

"""
    transpose(N::AbstractBipartiteNetwork)

Returns a transposed copy of the network.
"""
function transpose(N::AbstractEcologicalNetwork)
  A = copy(N.A)'
  return typeof(N)(A, species_objects(N)...)
end
