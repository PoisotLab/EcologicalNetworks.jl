Probabilistic(M::Matrix{T}) where {T <: AbstractFloat} = Probabilistic(dropzeros(sparse(M)))

@testitem "We can construct probabilistic edges from a matrix of floats" begin
    M = rand(Float64, (10, 10))
    @test eltype(Probabilistic(M)) == eltype(M)
end

Binary(M::Matrix{T}) where {T <: Bool} = Binary(dropzeros(sparse(M)))
Binary(M::BitMatrix) = Binary(dropzeros(sparse(M)))

@testitem "We can construct edges from a matrix of booleans" begin
    M = rand(Bool, (10, 10))
    @test eltype(Binary(M)) == eltype(M)
end

@testitem "We can construct edges from a matrix of bits" begin
    M = rand(Float64, (10, 10)) .< 0.2
    @test eltype(Binary(M)) == eltype(M)
end

Quantitative(M::Matrix{T}) where {T <: Number} = Quantitative(dropzeros(sparse(M)))

@testitem "We can construct quantitative edges from a matrix of numbers" begin
    M = floor.(Int64, rand(Float64, (10, 10)).*10.0)
    @test eltype(Quantitative(M)) == eltype(M)
end

function Bipartite(E::Interactions)
    rt, rb = size(E.edges)
    top = Symbol.("top_" .* string.(1:rt))
    bottom = Symbol.("bottom_" .* string.(1:rb))
    return Bipartite(top, bottom)
end

function Unipartite(E::Interactions)
    rt, rb = size(E.edges)
    if rt != rb
        throw(DimensionMismatch("The edges object has size $(rt), $(rb)"))
    end
    nodes = Symbol.("node_" .* string.(1:rt))
    return Unipartite(nodes)
end

@testitem "We can construct a unipartite set from an interaction struct" begin
    E = Binary(rand(Bool, (4, 4)))
    S = Unipartite(E)
    @test richness(S) == 4
end

@testitem "We cannot construct a unipartite set from an interaction struct with different sizes" begin
    E = Binary(rand(Bool, (4, 5)))
    @test_throws DimensionMismatch Unipartite(E)
end

function SpeciesInteractionNetwork{P, E}(M::Matrix{T}) where {T, P <: Partiteness, E <: Interactions}
    edges = E(M)
    nodes = P(edges)
    return SpeciesInteractionNetwork{P,E}(nodes, edges)
end

@testitem "We can construct a bipartite probabilistic network from a matrix" begin
    M = rand(Float64, (12, 10))
    N = SpeciesInteractionNetwork{Bipartite, Probabilistic}(M)
    @test richness(N) == sum(size(M))
    @test eltype(N.edges) == eltype(M)
    @test eltype(N.nodes) == Symbol
end

@testitem "We can construct a unipartite probabilistic network from a matrix" begin
    M = rand(Float64, (12, 12))
    N = SpeciesInteractionNetwork{Unipartite, Probabilistic}(M)
    @test richness(N) == size(M, 1)
    @test eltype(N.edges) == eltype(M)
    @test eltype(N.nodes) == Symbol
end

@testitem "We can construct a unipartite binary network from a matrix" begin
    M = rand(Bool, (12, 12))
    N = SpeciesInteractionNetwork{Unipartite, Binary}(M)
    @test richness(N) == size(M, 1)
    @test eltype(N.edges) == eltype(M)
    @test eltype(N.nodes) == Symbol
end