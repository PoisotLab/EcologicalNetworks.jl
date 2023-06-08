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

@testitem "We can declare a bipartite species set with strings" begin
    set = Bipartite(["a", "b", "c"], ["A", "B", "C", "D"])
    @test richness(set) == 7
end

@testitem "We cannot declare a bipartite set with species on both sides" begin
    @test_throws ArgumentError Bipartite([:a, :b, :c], [:A, :a])
end

@testitem "We cannot declare a bipartite set with non-unique species" begin
    @test_throws ArgumentError Bipartite([:a, :b, :b], [:A, :B])
end

struct Unipartite{T <: Any} <: Partiteness
    margin::Vector{T}
end

@testitem "We can declare a unipartite species set with symbols" begin
    set = Unipartite([:a, :b, :c])
    @test richness(set) == 3
end

@testitem "We can declare a unipartite species set with strings" begin
    set = Unipartite(["a", "b", "c"])
    @test richness(set) == 3
end

@testitem "We cannot declare a unipartite set with non-unique species" begin
    @test_throws ArgumentError Unipartite([:a, :b, :b])
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