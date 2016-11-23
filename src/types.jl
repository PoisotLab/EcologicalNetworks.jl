using Base

"""
EcoNetwork type


This is an abstract type that allows to generate functions for all sorts of
networks. All other types are derived from this one.
"""
abstract EcoNetwork

"""
Unipartite type

All unipartite networks
"""
abstract Unipartite <: EcoNetwork

"""
Bipartite type

All bipartite networks
"""
abstract Bipartite <: EcoNetwork

"""
BipartiteNetwork

A bipartite deterministic network.
"""
type BipartiteNetwork <: Bipartite
    A::Array{Bool, 2}
end

"""
Construct a bipartite network from a matrix of integer
"""
function BipartiteNetwork(A::Array{Int64, 2})

    # It can only be 0s and 1s
    u_val = sort(unique(A))
    # The following line will allow fully connected or emmpty networks
    @assert u_val == vec([0 1]) || u_val == vec([0]) || u_val == vec([1])

    # Return
    return BipartiteNetwork(map(Bool, A))
end

"""
UnipartiteNetwork

An unipartite deterministic network.
"""
type UnipartiteNetwork <: Unipartite
    A::Array{Bool, 2}
    UnipartiteNetwork(A) = size(A, 1) == size(A, 2) ? new(A) : error("Unequal size")
end

"""
Construct an unipartite network from a matrix of integer
"""
function UnipartiteNetwork(A::Array{Int64, 2})

    # It can only be 0s and 1s
    u_val = sort(unique(A))
    # The following line will allow fully connected or emmpty networks
    @assert u_val == vec([0 1]) || u_val == vec([0]) || u_val == vec([1])

    # Return
    return UnipartiteNetwork(map(Bool, A))
end


type BipartiteProbaNetwork <: Bipartite
    A::Array{Float64, 2}
end

type UnipartiteProbaNetwork <: Unipartite
    A::Array{Float64, 2}
    UnipartiteProbaNetwork(A) = size(A, 1) == size(A, 2) ? new(A) : error("Unequal size")
end

"""
Probabilistic network

This is a union type for both Bipartite and Unipartite probabilistic networks.
Probabilistic networks are represented as arrays of floating point values ∈
[0;1].
"""
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

function Base.copy(N::EcoNetwork)
    return typeof(N)(N.A)
end

"""
Return a transposed network with the correct type
"""
function Base.transpose(N::EcoNetwork)
    return typeof(N)(transpose(N.A))
end

"""
Getindex custom to get interaction value from an EcoNetwork
"""
function Base.getindex(N::EcoNetwork, i...)
    return getindex(N.A, i...)
end

function nrows(N::EcoNetwork)
    return size(N.A, 1)
end

function ncols(N::EcoNetwork)
    return size(N.A, 2)
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
