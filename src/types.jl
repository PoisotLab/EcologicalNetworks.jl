using Base

abstract EcoNetwork
abstract Unipartite <: EcoNetwork
abstract Bipartite <: EcoNetwork

type BipartiteNetwork <: Bipartite
    A::Array{Bool, 2}
end

type UnipartiteNetwork <: Unipartite
    A::Array{Bool, 2}
    UnipartiteNetwork(A) = size(A, 1) == size(A, 2) ? new(A) : error("Unequal size")
end

type BipartiteProbaNetwork <: Bipartite
    A::Array{Float64, 2}
end

type UnipartiteProbaNetwork <: Unipartite
    A::Array{Float64, 2}
    UnipartiteProbaNetwork(A) = size(A, 1) == size(A, 2) ? new(A) : error("Unequal size")
end

ProbabilisticNetwork = Union{BipartiteProbaNetwork, UnipartiteProbaNetwork}
DeterministicNetwork = Union{BipartiteNetwork, UnipartiteNetwork}

"""
Show the matrix from an EcoNetwork object
"""
function Base.show(N::EcoNetwork)
    Base.show(N.A)
end

function Base.size(N::EcoNetwork)
    Base.size(N.A)
end

"""
Richness (number of species) in a bipartite network
"""
function richness(N::Bipartite)
    return sum(size(N.A))
end

"""
Richness (number of species) in a unipartite network
"""
function richness(N::Unipartite)
    return size(N.A, 1)
end
