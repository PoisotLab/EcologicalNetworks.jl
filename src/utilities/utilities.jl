function _interaction_type(N::T) where {T <: AbstractEcologicalNetwork}
    return eltype(N.edges)
end

function _species_type(N::T) where {T <: AbstractBipartiteNetwork}
    return eltype(N.B)
end

function _species_type(N::T) where {T <: AbstractUnipartiteNetwork}
    return eltype(N.S)
end

function _check_species_validity(::Type{T}) where {T <: Any}
  throw(ArgumentError("The type $(T) is not an allowed species type"))
end

_check_species_validity(::Type{T}) where {T <: Symbol} = nothing
_check_species_validity(::Type{T}) where {T <: AbstractString} = nothing
_check_species_validity(::Type{T}) where {T <: String} = nothing

"""
    richness(N::AbstractEcologicalNetwork, i::Int64)

Returns the number of species on either side of the network. The value of `i`
can be `1` (top-level species) or `2` (bottom-level species), as in the
`species` function.
"""
function richness(N::AbstractEcologicalNetwork; dims::Union{Nothing,Integer}=nothing)
  return length(species(N; dims=dims))
end

"""
    species(N::AbstractBipartiteNetwork)

Returns an array of all species in a bipartite network. The order of the species
corresponds to the order of rows (top level) and columns (bottom level) of the
adjacency matrix, in this order.
"""
function species(N::AbstractBipartiteNetwork; dims::Union{Nothing,Integer}=nothing)
  isnothing(dims) && return vcat(N.T, N.B)
  dims == 1 && return N.T
  dims == 2 && return N.B
  throw(ArgumentError("dims can only be 1 (top species) or 2 (bottom species), or `nothing` (all species), you used $(dims)"))
end

"""
    species(N::AbstractUnipartiteNetwork; dims::Int64=1)

Returns an array of species on either side of a unipartite network. In a
unipartite network, species are the same on either size. This function is
nevertheless useful when you want to write code that takes either side of the
network in a general way.
"""
function species(N::AbstractUnipartiteNetwork; dims::Union{Nothing,Integer}=nothing)
  return N.S
end

function _species_objects(N::AbstractUnipartiteNetwork)
  return (N.S,)
end

function _species_objects(N::AbstractBipartiteNetwork)
  return (N.T, N.B)
end

"""
    has_interaction{(N::AbstractEcologicalNetwork, i::NT, j::NT)

This function returns `true` if the interaction between `i` and `j` is not 0.
This refers to species by their names/values, and is the recommended way to test
for the presence of an interaction.

Use `N[i,j]` if you need to get the value of the interaction.
"""
function has_interaction(N::AbstractEcologicalNetwork, i::NT, j::NT) where {NT}
  _check_species_validity(NT)
  @assert i ∈ species(N; dims=1)
  @assert j ∈ species(N; dims=2)
  i_pos = something(findfirst(isequal(i), species(N; dims=1)),0)
  j_pos = something(findfirst(isequal(j), species(N; dims=2)),0)
  return has_interaction(N, i_pos, j_pos)
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
  @assert i <= size(N.edges, 1)
  @assert j <= size(N.edges, 2)
  # This should be reasonably general...
  return !iszero(N[i,j])
end

"""
    nodiagonal!(N::AbstractUnipartiteNetwork)

Modifies the network so that its diagonal is set to the appropriate zero.
"""
function nodiagonal!(N::AbstractUnipartiteNetwork)
  N.edges[diagind(N.edges)] .= zero(eltype(N.edges))
end

"""
    nodiagonal(N::AbstractUnipartiteNetwork)

Returns a copy of the network with its diagonal set to zero.
"""
function nodiagonal(N::AbstractUnipartiteNetwork)
  Y = copy(N)
  nodiagonal!(Y)
  return Y
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
    nodiagonal!(N::AbstractBipartiteNetwork)

Does nothing.
"""
function nodiagonal!(N::AbstractBipartiteNetwork)
end

"""
    interactions(N::AbstractEcologicalNetwork)

Returns the interactions in the ecological network. Interactions are returned as
an array of named tuples. *A minima*, these have fields `from` and `to`. For
networks that are probabilistic, there is a `probability` field. For networks
that are quantitative, there is a `strength` field. This functions allows to
iterate over interactions in a network in a convenient way.
"""
function interactions(N::BinaryNetwork)
    non_zero = count(!iszero, N.edges) # Number of non-zero entries in the matrix
    t_int, t_spe = _interaction_type(N), _species_type(N)
    edges_accumulator = Vector{NamedTuple{tuple(:from, :to),Tuple{t_spe, t_spe}}}(undef, non_zero)
    sp1 = species(N; dims=1)
    sp2 = species(N; dims=2)
    I, J, V = findnz(N.edges)
    for i in eachindex(I)
        edges_accumulator[i] = (from = sp1[I[i]], to = sp2[J[i]])
    end
    return unique(edges_accumulator)
end

function interactions(N::QuantitativeNetwork)
    non_zero = count(!iszero, N.edges) # Number of non-zero entries in the matrix
    t_int, t_spe = _interaction_type(N), _species_type(N)
    edges_accumulator = Vector{NamedTuple{tuple(:from, :to, :strength),Tuple{t_spe, t_spe, t_int}}}(undef, non_zero)
    sp1 = species(N; dims=1)
    sp2 = species(N; dims=2)
    I, J, V = findnz(N.edges)
    for i in eachindex(I)
        edges_accumulator[i] = (from = sp1[I[i]], to = sp2[J[i]], strength = V[i])
    end
    return unique(edges_accumulator)
end

function interactions(N::ProbabilisticNetwork)
    non_zero = count(!iszero, N.edges) # Number of non-zero entries in the matrix
    t_int, t_spe = _interaction_type(N), _species_type(N)
    edges_accumulator = Vector{NamedTuple{tuple(:from, :to, :probability),Tuple{t_spe, t_spe, t_int}}}(undef, non_zero)
    sp1 = species(N; dims=1)
    sp2 = species(N; dims=2)
    I, J, V = findnz(N.edges)
    for i in eachindex(I)
        edges_accumulator[i] = (from = sp1[I[i]], to = sp2[J[i]], probability = V[i])
    end
    return unique(edges_accumulator)
end