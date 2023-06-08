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
Base.getindex(E::Interactions, i::Integer, ::Colon) = E.edges[i,:]
Base.getindex(E::Interactions, ::Colon, j::Integer) = E.edges[:,j]

Base.getindex(N::SpeciesInteractionNetwork, i::Integer, j::Integer) = N.edges[i,j]
Base.getindex(N::SpeciesInteractionNetwork, i::Integer, ::Colon) = N.edges[i,:]
Base.getindex(N::SpeciesInteractionNetwork, ::Colon, j::Integer) = N.edges[:,j]

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

@testitem "We can get a slice of the network by position" begin
    M = [1 2 3; 4 5 6]
    N = SpeciesInteractionNetwork{Bipartite, Quantitative}(M)
    for i in axes(N, 1)
        @test N[i,:] == M[i,:]
    end
    for j in axes(N, 2)
        @test N[:,j] == M[:,j]
    end
end

function Base.getindex(N::SpeciesInteractionNetwork{Bipartite{T}, <:Interactions}, s1::T, s2::T) where {T}
    i = findfirst(isequal(s1), N.nodes.top)
    j = findfirst(isequal(s2), N.nodes.bottom)
    if isnothing(i)
        throw(ArgumentError("The species $(s1) is not part of the network"))
    end
    if isnothing(j)
        throw(ArgumentError("The species $(s2) is not part of the network"))
    end
    return N[i,j]
end

function Base.getindex(N::SpeciesInteractionNetwork{Bipartite{T}, <:Interactions}, s1::T, ::Colon) where {T}
    i = findfirst(isequal(s1), N.nodes.top)
    if isnothing(i)
        throw(ArgumentError("The species $(s1) is not part of the network"))
    end
    return N[i,:]
end

function Base.getindex(N::SpeciesInteractionNetwork{Bipartite{T}, <:Interactions}, ::Colon, s2::T) where {T}
    j = findfirst(isequal(s2), N.nodes.bottom)
    if isnothing(j)
        throw(ArgumentError("The species $(s2) is not part of the network"))
    end
    return N[:,j]
end

function Base.getindex(N::SpeciesInteractionNetwork{Unipartite{T}, <:Interactions}, s1::T, s2::T) where {T}
    i = findfirst(isequal(s1), N.nodes.margin)
    j = findfirst(isequal(s2), N.nodes.margin)
    if isnothing(i)
        throw(ArgumentError("The species $(s1) is not part of the network"))
    end
    if isnothing(j)
        throw(ArgumentError("The species $(s2) is not part of the network"))
    end
    return N[i,j]
end

function Base.getindex(N::SpeciesInteractionNetwork{Unipartite{T}, <:Interactions}, s1::T, ::Colon) where {T}
    i = findfirst(isequal(s1), N.nodes.margin)
    if isnothing(i)
        throw(ArgumentError("The species $(s1) is not part of the network"))
    end
    return N[i,:]
end

function Base.getindex(N::SpeciesInteractionNetwork{Unipartite{T}, <:Interactions}, ::Colon, s2::T) where {T}
    j = findfirst(isequal(s2), N.nodes.margin)
    if isnothing(j)
        throw(ArgumentError("The species $(s2) is not part of the network"))
    end
    return N[:,j]
end

@testitem "We can index a bipartite network using the species names" begin
    edges = Quantitative([1 2 3; 4 5 6])
    nodes = Bipartite([:A, :B], [:a, :b, :c])
    B = SpeciesInteractionNetwork(nodes, edges)
    @test B[:A, :a] == 1
    @test B[:A, :b] == 2
    @test B[:A, :c] == 3
    @test B[:B, :a] == 4
    @test B[:B, :b] == 5
    @test B[:B, :c] == 6
end

@testitem "We can index a unipartite network using the species names" begin
    edges = Binary([false true; true false])
    nodes = Unipartite([:A, :B])
    U = SpeciesInteractionNetwork(nodes, edges)
    @test U[:A, :] == U[1,:]
    @test U[:, :B] == U[:,2]
end

@testitem "We can slice a network using species names" begin
    edges = Quantitative([1 2 3; 4 5 6])
    nodes = Bipartite([:A, :B], [:a, :b, :c])
    B = SpeciesInteractionNetwork(nodes, edges)
    @test B[:A, :a] == 1
    @test B[:A, :b] == 2
    @test B[:A, :c] == 3
    @test B[:B, :a] == 4
    @test B[:B, :b] == 5
    @test B[:B, :c] == 6
end

@testitem "We cannot index using a species that is not in the network" begin
    edges = Binary([false true; true false])
    nodes = Unipartite([:A, :B])
    U = SpeciesInteractionNetwork(nodes, edges)
    @test_throws ArgumentError U[:C, :D]
end

function Base.similar(N::SpeciesInteractionNetwork{P,E}) where {P <: Partiteness, E <: Interactions}
    new_edges = E(sparse(zeros(eltype(N.edges), size(N))))
    return SpeciesInteractionNetwork(N.nodes, new_edges)
end

@testitem "We can construct a similar network from a binary network" begin
    N = SpeciesInteractionNetwork{Bipartite, Binary}(rand(Bool, (3, 4)))
    S = similar(N)
    for i in axes(N,1)
        for j in axes(N,2)
            @test iszero(S[i,j])
        end
    end
end

@testitem "We can construct a similar network from a quantitative network" begin
    N = SpeciesInteractionNetwork{Unipartite, Quantitative}(rand(Float64, (5, 5)))
    S = similar(N)
    for i in axes(N,1)
        for j in axes(N,2)
            @test iszero(S[i,j])
        end
    end
end

@testitem "We can construct a similar network from a probabilistic network" begin
    N = SpeciesInteractionNetwork{Unipartite, Probabilistic}(rand(Float64, (5, 5)))
    S = similar(N)
    for i in axes(N,1)
        for j in axes(N,2)
            @test iszero(S[i,j])
        end
    end
end

#=
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