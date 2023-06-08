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
    function Bipartite(top::Vector{T}, bottom::Vector{T}) where {T <: Any}
        if ~allunique(top)
            throw(ArgumentError("The species in the top level of a bipartite network must be unique"))
        end
        if ~allunique(bottom)
            throw(ArgumentError("The species in the bottom level of a bipartite network must be unique"))
        end
        if ~allunique(vcat(bottom, top))
            throw(ArgumentError("The species in a bipartite network cannot appear in both levels"))
        end
        return new{T}(top, bottom)
    end
end

@testitem "We can construct a bipartite species set with symbols" begin
    set = Bipartite([:a, :b, :c], [:A, :B, :C])
    @test richness(set) == 6
end

@testitem "We can construct a bipartite species set with strings" begin
    set = Bipartite(["a", "b", "c"], ["A", "B", "C", "D"])
    @test richness(set) == 7
end

@testitem "We cannot construct a bipartite set with species on both sides" begin
    @test_throws ArgumentError Bipartite([:a, :b, :c], [:A, :a])
end

@testitem "We cannot construct a bipartite set with non-unique species" begin
    @test_throws ArgumentError Bipartite([:a, :b, :b], [:A, :B])
end

struct Unipartite{T <: Any} <: Partiteness
    margin::Vector{T}
    function Unipartite(margin::Vector{T}) where {T <: Any}
        if ~allunique(margin)
            throw(ArgumentError("The species in a unipartite network must be unique"))
        end
        return new{T}(margin)
    end
end

@testitem "We can construct a unipartite species set with symbols" begin
    set = Unipartite([:a, :b, :c])
    @test richness(set) == 3
end

@testitem "We can construct a unipartite species set with strings" begin
    set = Unipartite(["a", "b", "c"])
    @test richness(set) == 3
end

@testitem "We cannot construct a unipartite set with non-unique species" begin
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

@testitem "We can construct a unipartite probabilistic network" begin
    nodes = Unipartite([:a, :b, :c])
    edges = Binary(rand(Bool, (3,3)))
    N = SpeciesInteractionNetwork(nodes, edges)
    @test richness(N) == 3
    @test species(N) == [:a, :b, :c]
end