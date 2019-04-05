import Base: getindex, setindex!, permutedims, permutedims!, size, copy, !, show, +

is_valid_species(::Type{T}) where {T} = true
is_valid_species(::Type{T}) where {T <: Number} = false

"""
    show(io::IO, N::AbstractEcologicalNetwork)
"""
function show(io::IO, N::AbstractEcologicalNetwork)
  p = typeof(N) <: AbstractBipartiteNetwork ? "bipartite" : "unipartite"
  t = ""
  t = typeof(N) <: ProbabilisticNetwork ? "probabilistic" : t
  t = typeof(N) <: QuantitativeNetwork ? "quantitative" : t
  print(io, "$(richness(N; dims=1))×$(richness(N; dims=2)) $(p) $(t) ecological network $(eltype(N)) (L: $(links(N)))")
end

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
  dims === nothing && return vcat(N.T, N.B)
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

function species_objects(N::AbstractUnipartiteNetwork)
  return (N.S,)
end

function species_objects(N::AbstractBipartiteNetwork)
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
  @assert is_valid_species(NT)
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
  @assert i <= size(N.A, 1)
  @assert j <= size(N.A, 2)
  # This should be reasonably general...
  return N[i,j] != zero(typeof(N[i,j]))
end

"""
    nodiagonal!(N::AbstractUnipartiteNetwork)

Modifies the network so that its diagonal is set to the appropriate zero.
"""
function nodiagonal!(N::AbstractUnipartiteNetwork)
  for i in 1:richness(N)
    N.A[i,i] = zero(eltype(N.A))
  end
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
    getindex(N::AbstractEcologicalNetwork, i::T, j::T)

Get the value of an interaction based on the position of the species.
"""
function getindex(N::AbstractEcologicalNetwork, i::T, j::T) where {T <: Int}
  return N.A[i,j]
end

"""
    getindex(N::AbstractEcologicalNetwork, i::T)

Get the value of an interaction based on the position of the species.
"""
function getindex(N::AbstractEcologicalNetwork, i::T) where {T <: Int}
  return N.A[i]
end


"""
    getindex(N::AbstractEcologicalNetwork, ::Colon, j::T)

Get the value of an interaction based on the position of the species.
"""
function getindex(N::AbstractEcologicalNetwork, ::Colon, j::T) where {T <: Int}
  return N.A[:,j]
end

"""
    getindex(N::AbstractEcologicalNetwork, i::T, ::Colon)

Get the value of an interaction based on the position of the species.
"""
function getindex(N::AbstractEcologicalNetwork, i::T, ::Colon) where {T <: Int}
  return N.A[i,:]
end

"""
    getindex{T}(N::AbstractEcologicalNetwork, s1::T, s2::T)

Get the value of an interaction based on the *name* of the species. This is the
recommended way to look for things in a network.
"""
function getindex(N::AbstractEcologicalNetwork, s1::T, s2::T) where {T}
  @assert is_valid_species(T)
  @assert s1 ∈ species(N; dims=1)
  @assert s2 ∈ species(N; dims=2)
  s1_pos = something(findfirst(isequal(s1), species(N; dims=1)), 0)
  s2_pos = something(findfirst(isequal(s2), species(N; dims=2)), 0)
  return N[s1_pos, s2_pos]
end


"""
    getindex{T}(N::AbstractBipartiteNetwork, ::Colon, sp::T)

Gets the predecessors (*i.e.* species that interacts with / consume) of a focal
species. This returns the list of species as a `Set` object, in which ordering
is unimportant.
"""
function getindex(N::AbstractEcologicalNetwork, ::Colon, sp::T) where {T}
  @assert is_valid_species(T)
  @assert sp ∈ species(N; dims=2)
  return Set(filter(x -> has_interaction(N, x, sp), species(N; dims=1)))
end


"""
    getindex{T}(N::AbstractEcologicalNetwork, sp::T, ::Colon)

Gets the successors (*i.e.* species that are interacted with / consumed) of a
focal species. This returns the list of species as a `Set` object, in which
ordering is unimportant.
"""
function getindex(N::AbstractEcologicalNetwork, sp::T, ::Colon) where {T}
  @assert is_valid_species(T)
  @assert sp ∈ species(N; dims=1)
  return Set(filter(x -> has_interaction(N, sp, x), species(N; dims=2)))
end


"""
    getindex{T}(N::AbstractUnipartiteNetwork, sp::Array{T})

Induce a unipartite network based on a list of species, all of which must be in
the original network. This function takes a single argument (as opposed to two
arrays, or an array and a colon) to ensure that the returned network is
unipartite.

The network which is returned by this function may not have the species in the
order specified by the user for performance reasons.
"""
function getindex(N::AbstractUnipartiteNetwork, sp::Vector{T}) where {T}
  @assert is_valid_species(T)
  @assert all(map(x -> x ∈ species(N), sp))
  sp_pos = findall((in)(sp), species(N))
  n_sp = species(N)[sp_pos]
  n_int = N.A[sp_pos, sp_pos]
  return typeof(N)(n_int, n_sp)
end


"""
    getindex{T}(N::AbstractBipartiteNetwork, ::Colon, sp::Array{T})

TODO
"""
function getindex(N::AbstractBipartiteNetwork, ::Colon, sp::Vector{T}) where {T}
  @assert is_valid_species(T)
  @assert all(map(x -> x ∈ species(N; dims=2), sp))
  sp_pos = findall((in)(sp), species(N; dims=2))
  n_t = N.T
  n_b = N.B[sp_pos]
  n_int = N.A[:, sp_pos]
  return typeof(N)(n_int, n_t, n_b)
end


"""
    getindex{T}(N::AbstractBipartiteNetwork, sp::Array{T}, ::Colon)

TODO
"""
function getindex(N::AbstractBipartiteNetwork, sp::Vector{T}, ::Colon) where {T}
  @assert is_valid_species(T)
  @assert all(map(x -> x ∈ species(N; dims=1), sp))
  sp_pos = findall((in)(sp), species(N; dims=1))
  n_t = N.T[sp_pos]
  n_b = N.B
  n_int = N.A[sp_pos,:]
  return typeof(N)(n_int, n_t, n_b)
end


"""
    getindex{T}(N::AbstractBipartiteNetwork, sp1::Array{T}, sp2::Array{T})

TODO
"""
function getindex(N::AbstractBipartiteNetwork, sp1::Vector{T}, sp2::Vector{T}) where {T}
  @assert is_valid_species(T)
  @assert all(map(x -> x ∈ species(N; dims=1), sp1))
  @assert all(map(x -> x ∈ species(N; dims=2), sp2))
  sp1_pos = findall((in)(sp1), species(N; dims=1))
  sp2_pos = findall((in)(sp2), species(N; dims=2))
  n_t = N.T[sp1_pos]
  n_b = N.B[sp2_pos]
  n_int = N.A[sp1_pos,sp2_pos]
  return typeof(N)(n_int, n_t, n_b)
end

"""
    setindex!(N::T, A::Any, i::E, j::E) where {T <: AbstractEcologicalNetwork, E}

Changes the value of the interaction at the specificied position, where `i` and
`j` are species *names*. Note that this operation **changes the network**.
"""
function setindex!(N::T, A::Any, i::E, j::E) where {T <: AbstractEcologicalNetwork, E}
  @assert is_valid_species(T)
  @assert i ∈ species(N; dims=1)
  @assert j ∈ species(N; dims=2)
  i_pos = something(findfirst(isequal(i), species(N; dims=1)),0)
  j_pos = something(findfirst(isequal(j), species(N; dims=2)),0)
  N.A[i_pos, j_pos] = A
end

"""
    setindex!(N::T, A::K, i::E, j::E) where {T <: AbstractEcologicalNetwork, K <: first(eltype(N)), E <: Int}

Changes the value of the interaction at the specificied position, where `i` and
`j` are species *positions*. Note that this operation **changes the network**.
"""
function setindex!(N::T, A::Any, i::E, j::E) where {T <: AbstractEcologicalNetwork, E <: Int}
  @assert i ≤ richness(N; dims=1)
  @assert j ≤ richness(N; dims=2)
  N.A[i, j] = A
end

"""
    Base.:!{T<:DeterministicNetwork}(N::T)

Returns the inverse of a binary network -- interactions that were `false` become
`true`, and conversely.
"""
function Base.:!(N::T) where {T <: BinaryNetwork}
  return typeof(N)(.!N.A, species_objects(N)...)
end


"""
    permutedims(N::AbstractBipartiteNetwork)

Tranposes the network and returns a copy
"""
function permutedims(N::AbstractEcologicalNetwork)
  NA = permutedims(N.A)
  new_sp = typeof(N) <: AbstractBipartiteNetwork ? (N.B, N.T) : (N.S,)
  return typeof(N)(NA, new_sp...)
end

"""
    interactions(N::AbstractEcologicalNetwork)

Returns the interactions in the ecological network. Interactions are returned as
an array of named tuples. *A minima*, these have fields `from` and `to`. For
networks that are probabilistic, there is a `probability` field. For networks
that are quantitative, there is a `strength` field. This functions allows to
iterate over interactions in a network in a convenient way.
"""
function interactions(N::AbstractEcologicalNetwork)
  edges_accumulator = NamedTuple[]
  fields = [:from, :to]
  if typeof(N) <: ProbabilisticNetwork
    push!(fields, :probability)
  end
  if typeof(N) <: QuantitativeNetwork
    push!(fields, :strength)
  end
  sp1 = species(N; dims=1)
  sp2 = species(N; dims=2)
  for i in eachindex(sp1)
    s1 = sp1[i]
    for j in eachindex(sp2)
      if has_interaction(N, i, j)
        values = Any[s1, sp2[j]]
        if typeof(N) <: ProbabilisticNetwork
          push!(values, N[i,j])
        end
        if typeof(N) <: QuantitativeNetwork
          push!(values, N[i,j])
        end
        int_nt = NamedTuple{tuple(fields...)}(tuple(values...))
        push!(edges_accumulator, int_nt)
      end
    end
  end
  return unique(edges_accumulator)
end

"""
    +(n1::T, n2::T) where {T <: BipartiteQuantitativeNetwork}

Adds two quantitative bipartite networks. TODO
"""
function +(n1::T, n2::T) where {T <: BipartiteQuantitativeNetwork}
  st = union(species(n1; dims=1), species(n2; dims=1))
  sb = union(species(n1; dims=2), species(n2; dims=2))
  A = zeros(first(eltype(n1)), (length(st), length(sb)))
  N = T(A, st, sb)
  for i1 in n1
    N[i1.from,i1.to] = N[i1.from,i1.to] + i1.strength
  end
  for i2 in n2
    N[i2.from,i2.to] = N[i2.from,i2.to] + i2.strength
  end
  return N
end
