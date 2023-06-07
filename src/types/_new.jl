abstract type Partiteness end
abstract type Interactions end

struct SpeciesInteractionNetwork{P<:Partiteness, E<:Interactions}
    nodes::P
    edges::E
end

using SparseArrays
using TestItems

struct Bipartite{T <: Any} <: Partiteness
    top::Vector{T}
    bottom::Vector{T}
end

@testitem "We can declare a bipartite species set with symbols" begin
    set = Bipartite([:a, :b, :c], [:A, :B, :C])
    @test richness(set) == 6
end

struct Unipartite{T <: Any} <: Partiteness
    margin::Vector{T}
end

@testitem "We can declare a unipartite species set with symbols" begin
    set = Unipartite([:a, :b, :c])
    @test richness(set) == 3
end

struct Probabilistic{T <: AbstractFloat} <: Interactions
    edges::SparseMatrixCSC{T}
end

struct Quantitative{T <: Number} <: Interactions
    edges::SparseMatrixCSC{T}
end

struct Binary{Bool} <: Interactions
    edges::SparseMatrixCSC{Bool}
end


@testitem "We can declare a unipartite probabilistic network" begin
    nodes = Unipartite([:a, :b, :c])
    edges = Binary(sparse(rand(Bool, (3,3))))
    N = SpeciesInteractionNetwork(nodes, edges)
    @test richnes(N) == 3
    @test species(N) == [:a, :b, :c]
end

species(N::Bipartite) = vcat(N.top, N.bottom)
species(N::Unipartite) = N.margin
species(N::SpeciesInteractionNetwork) = species(N.nodes)

richness(N::Partiteness) = length(species(N))
richness(N::SpeciesInteractionNetwork) = length(species(N.nodes))