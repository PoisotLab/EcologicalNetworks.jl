"""
    Base.length(N::T) where {T <: AbstractEcologicalNetwork}

The length of a network is the number of non-zero elements in it.
"""
Base.length(N::SpeciesInteractionNetwork) = count(!iszero, N.edges.edges)

@testitem "The length of a network is the number of interactions" begin
    M = rand(Bool, (10, 10))
    N = SpeciesInteractionNetwork{Unipartite,Binary}(M)
    @test length(N) == sum(M)
end

Base.axes(E::Interactions) = axes(E.edges)
Base.axes(E::Interactions, i::Integer) = axes(E.edges, i)

Base.axes(N::SpeciesInteractionNetwork) = axes(N.edges)
Base.axes(N::SpeciesInteractionNetwork, i::Integer) = axes(N.edges, i)

Base.size(E::Interactions) = size(E.edges)
Base.size(E::Interactions, i::Integer) = size(E.edges, i)

Base.size(N::SpeciesInteractionNetwork) = size(N.edges)
Base.size(N::SpeciesInteractionNetwork, i::Integer) = size(N.edges, i)

@testitem "The size of a network is the size of its edges matrix" begin
    M = rand(Bool, (12, 14))
    N = SpeciesInteractionNetwork{Bipartite, Binary}(M)
    @test size(M) == size(N.edges.edges)
    @test size(M,1) == size(N.edges.edges,1)
    @test size(M,2) == size(N.edges.edges,2)
end

Base.getindex(E::Interactions, i::Integer, j::Integer) = E.edges[i,j]
Base.getindex(N::SpeciesInteractionNetwork, i::Integer, j::Integer) = N.edges[i,j]

@testitem "We can get an interaction in the edges of a network by position" begin
    M = rand(Bool, (12, 14))
    E = Binary(M)
    S = Bipartite(E)
    N = SpeciesInteractionNetwork(S,E)
    for i in axes(N,1)
        for j in axes(E,2)
            @test E[i,j] == M[i,j]
            @test N[i,j] == M[i,j]
            @test N[i,j] == E[i,j]
        end
    end
end

function Base.similar(N::SpeciesInteractionNetwork{P,E}) where {P <: Partiteness, E <: Interactions}
    new_edges = E(sparse(zeros(eltype(N.edges), size(N))))
    return SpeciesInteractionNetwork(N.nodes, new_edges)
end

@testitem "We can construct a similar network from a network" begin
    N = SpeciesInteractionNetwork{Bipartite, Binary}(rand(Bool, (3, 4)))
    S = similar(N)
    for i in axes(N,1)
        for j in axes(N,2)
            @test iszero(S[i,j])
        end
    end
end

#=
"""
    getindex(N::AbstractEcologicalNetwork, i::T)

Get the value of an interaction based on the position of the species.
"""
function Base.getindex(N::AbstractEcologicalNetwork, i::T) where {T <: Int}
  return N.edges[i]
end


"""
    getindex(N::AbstractEcologicalNetwork, ::Colon, j::T)

Get the value of an interaction based on the position of the species.
"""
function Base.getindex(N::AbstractEcologicalNetwork, ::Colon, j::T) where {T <: Int}
  return N.edges[:,j]
end

"""
    getindex(N::AbstractEcologicalNetwork, i::T, ::Colon)

Get the value of an interaction based on the position of the species.
"""
function Base.getindex(N::AbstractEcologicalNetwork, i::T, ::Colon) where {T <: Int}
  return N.edges[i,:]
end

"""
    getindex{T}(N::AbstractEcologicalNetwork, s1::T, s2::T)

Get the value of an interaction based on the *name* of the species. This is the
recommended way to look for things in a network.
"""
function Base.getindex(N::AbstractEcologicalNetwork, s1::T, s2::T) where {T}
  @assert T == _species_type(N)
  s1_pos = findfirst(isequal(s1), species(N; dims=1))
  s2_pos = findfirst(isequal(s2), species(N; dims=2))
  return N[s1_pos, s2_pos]
end


"""
    getindex{T}(N::AbstractBipartiteNetwork, ::Colon, sp::T)

Gets the predecessors (*i.e.* species that interacts with / consume) of a focal
species. This returns the list of species as a `Set` object, in which ordering
is unimportant.
"""
function Base.getindex(N::AbstractEcologicalNetwork, ::Colon, sp::T) where {T}
  @assert T == _species_type(N)
  j = findfirst(isequal(sp), species(N; dims=2))
  i = findall(!iszero, N[:,j])
  return Set(species(N; dims=1)[i])
end


"""
    getindex{T}(N::AbstractEcologicalNetwork, sp::T, ::Colon)

Gets the successors (*i.e.* species that are interacted with / consumed) of a
focal species. This returns the list of species as a `Set` object, in which
ordering is unimportant.
"""
function Base.getindex(N::AbstractEcologicalNetwork, sp::T, ::Colon) where {T}
  @assert T == _species_type(N)
  i = findfirst(isequal(sp), species(N; dims=1))
  j = findall(!iszero, N[i,:])
  return Set(species(N; dims=2)[j])
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
function Base.getindex(N::AbstractUnipartiteNetwork, sp::Vector{T}) where {T}
  @assert T == _species_type(N)
  sp_pos = indexin(sp, species(N))
  n_sp = species(N)[sp_pos]
  n_int = N.edges[sp_pos, sp_pos]
  return typeof(N)(n_int, n_sp)
end

"""
    getindex{T}(N::AbstractBipartiteNetwork, ::Colon, sp::Array{T})

TODO
"""
function Base.getindex(N::AbstractBipartiteNetwork, ::Colon, sp::Vector{T}) where {T}
  @assert T == _species_type(N)
  sp_pos = Int.(something(indexin(sp, species(N; dims=2))))
  n_t = N.T
  n_b = N.B[sp_pos]
  n_int = N.edges[:, sp_pos]
  return typeof(N)(n_int, n_t, n_b)
end


"""
    getindex{T}(N::AbstractBipartiteNetwork, sp::Array{T}, ::Colon)

TODO
"""
function Base.getindex(N::AbstractBipartiteNetwork, sp::Vector{T}, ::Colon) where {T}
  @assert T == _species_type(N)
  sp_pos = Int.(something(indexin(sp, species(N; dims=1))))
  n_t = N.T[sp_pos]
  n_b = N.B
  n_int = N.edges[sp_pos,:]
  return typeof(N)(n_int, n_t, n_b)
end


"""
    getindex{T}(N::AbstractBipartiteNetwork, sp1::Array{T}, sp2::Array{T})

TODO
"""
function Base.getindex(N::AbstractBipartiteNetwork, sp1::Vector{T}, sp2::Vector{T}) where {T <: Integer}
   @assert all(sp1 .<= richness(N; dims=1))
   @assert all(sp2 .<= richness(N; dims=2))
   n_t = N.T[sp1]
   n_b = N.B[sp2]
   n_int = N.edges[sp1,sp2]
   return typeof(N)(n_int, n_t, n_b)
end

"""
    getindex{T}(N::AbstractBipartiteNetwork, sp1::Array{T}, sp2::Array{T})

TODO
"""
function Base.getindex(N::AbstractBipartiteNetwork, sp1::Vector{T}, sp2::Vector{T}) where {T}
  @assert T == _species_type(N)
  sp1_pos = Int.(something(indexin(sp1, species(N; dims=1))))
  sp2_pos = Int.(something(indexin(sp2, species(N; dims=2))))
  return N[sp1_pos, sp2_pos]
end

"""
    setindex!(N::T, A::Any, i::E, j::E) where {T <: AbstractEcologicalNetwork, E}

Changes the value of the interaction at the specificied position, where `i` and
`j` are species *names*. Note that this operation **changes the network**.
"""
function Base.setindex!(N::T, A::Any, i::E, j::E) where {T <: AbstractEcologicalNetwork, E}
  @assert E == _species_type(N)
  @assert i ∈ species(N; dims=1)
  @assert j ∈ species(N; dims=2)
  i_pos = something(findfirst(isequal(i), species(N; dims=1)),0)
  j_pos = something(findfirst(isequal(j), species(N; dims=2)),0)
  N.edges[i_pos, j_pos] = A
end

"""
    setindex!(N::T, A::K, i::E, j::E) where {T <: AbstractEcologicalNetwork, K <: _interaction_type(N), E <: Int}

Changes the value of the interaction at the specificied position, where `i` and
`j` are species *positions*. Note that this operation **changes the network**.
"""
function Base.setindex!(N::T, A::Any, i::E, j::E) where {T <: AbstractEcologicalNetwork, E <: Int}
  @assert i ≤ richness(N; dims=1)
  @assert j ≤ richness(N; dims=2)
  N.edges[i, j] = A
end
=#