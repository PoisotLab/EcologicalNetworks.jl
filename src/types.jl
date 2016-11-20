using Base

abstract EcoNetwork
abstract Unipartite <: EcoNetwork
abstract Bipartite <: EcoNetwork

type BipartiteNetwork <: Bipartite
    A::Array{Int64, 2}
end

type UnipartiteNetwork <: Unipartite
    A::Array{Int64, 2}
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
General ecological network functions
"""
function Base.show(N::EcoNetwork)
    Base.show(N.A)
end

function Base.size(N::EcoNetwork)
    Base.size(N.A)
end

function richness(N::Bipartite)
    return sum(size(N.A))
end

function richness(N::Unipartite)
    return size(N.A, 1)
end
