abstract type Partiteness end
abstract type Interactions end

using SparseArrays

struct Bipartite{T <: Any} <: Partiteness
    top::Vector{T}
    bottom::Vector{T}
end

struct Unipartite{T <: Any} <: Partiteness
    species::Vector{T}
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

struct EcologicalNetwork{P<:Partiteness, E<:Interactions}
    species::P
    edges::E
end

nodes = Unipartite([:a, :b, :c])
edges = Binary(sparse(rand(Bool, (3,3))))

EcologicalNetwork(nodes, edges)