abstract type Partiteness end
abstract type Interactions end

using SparseArrays
using TestItems

struct Bipartite{T <: Any} <: Partiteness
    top::Vector{T}
    bottom::Vector{T}
end

struct Unipartite{T <: Any} <: Partiteness
    margin::Vector{T}
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

struct SpeciesInteractionNetwork{P<:Partiteness, E<:Interactions}
    nodes::P
    edges::E
end

@testitem "We can declare a unipartite probabilistic network" begin
    nodes = Unipartite([:a, :b, :c])
    edges = Binary(sparse(rand(Bool, (3,3))))
    N = SpeciesInteractionNetwork(nodes, edges)
    @test richnes(N) == 3
    @test species(N) == [:a, :b, :c]
end

species(N::SpeciesInteractionNetwork{P,E}) where {P<:Bipartite, E<:Interactions} = vcat(N.nodes.top, N.nodes.bottom)
species(N::SpeciesInteractionNetwork{P,E}) where {P<:Unipartite, E<:Interactions} = N.nodes.margin

richness(N::SpeciesInteractionNetwork) = length(species(N))