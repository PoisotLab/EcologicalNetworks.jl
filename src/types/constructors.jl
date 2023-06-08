function SpeciesInteractionNetwork{Bipartite, Probabilistic}(
    M::Matrix{T},
) where {T <: Number}
    ric = size(M)
    top = Symbol.("top_" .* string.(1:ric[1]))
    bottom = Symbol.("bottom_" .* string.(1:ric[2]))
    edges = Probabilistic(sparse(M))
    nodes = Bipartite(top, bottom)
    return SpeciesInteractionNetwork{Bipartite, Probabilistic}(nodes, edges)
end

@testitem "We can construct a bipartite probabilistic network from a matrix" begin
    M = rand(Float64, (12, 10))
    N = SpeciesInteractionNetwork{Bipartite, Probabilistic}(M)
    @test richness(N) == sum(size(M))
    @test eltype(N.edges) == eltype(M)
    @test eltype(N.nodes) == Symbol
end

function SpeciesInteractionNetwork{Unipartite, Probabilistic}(
    M::Matrix{T},
) where {T <: Number}
    ric = size(M)
    nodes = Unipartite(Symbol.("node_" .* string.(1:ric[1])))
    edges = Probabilistic(sparse(M))
    return SpeciesInteractionNetwork{Unipartite, Probabilistic}(nodes, edges)
end

@testitem "We can construct a unipartite probabilistic network from a matrix" begin
    M = rand(Float64, (12, 12))
    N = SpeciesInteractionNetwork{Unipartite, Probabilistic}(M)
    @test richness(N) == size(M, 1)
    @test eltype(N.edges) == eltype(M)
    @test eltype(N.nodes) == Symbol
end

function SpeciesInteractionNetwork{Unipartite, Binary}(
    M::Matrix{T},
) where {T <: Bool}
    ric = size(M)
    nodes = Unipartite(Symbol.("node_" .* string.(1:ric[1])))
    edges = Binary(sparse(M))
    return SpeciesInteractionNetwork{Unipartite, Binary}(nodes, edges)
end

@testitem "We can construct a unipartite binary network from a matrix" begin
    M = rand(Bool, (12, 12))
    N = SpeciesInteractionNetwork{Unipartite, Binary}(M)
    @test richness(N) == size(M, 1)
    @test eltype(N.edges) == eltype(M)
    @test eltype(N.nodes) == Symbol
end