using Base

"""
This is an abstract type that allows to generate functions for all sorts of
networks. All other types are derived from this one.
"""
abstract EcoNetwork

"""
All unipartite networks
"""
abstract Unipartite <: EcoNetwork

"""
All bipartite networks
"""
abstract Bipartite <: EcoNetwork

"""
A bipartite deterministic network is a two-dimensional array of boolean values.
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

type BipartiteQuantiNetwork <: Bipartite
    A::Array{Number, 2}
end

type UnipartiteQuantiNetwork <: Unipartite
    A::Array{Number, 2}
    UnipartiteQuantiNetwork(A) = size(A, 1) == size(A, 2) ? new(A) : error("Unequal size")
end

"""
This is a union type for both Bipartite and Unipartite probabilistic networks.
Probabilistic networks are represented as arrays of floating point values ∈
[0;1].
"""
ProbabilisticNetwork = Union{BipartiteProbaNetwork, UnipartiteProbaNetwork}

"""
This is a union type for both Bipartite and Unipartite deterministic networks.
All networks from these class have adjacency matrices represented as arrays of
Boolean values.
"""
DeterministicNetwork = Union{BipartiteNetwork, UnipartiteNetwork}

"""
This is a union type for both unipartite and bipartite quantitative networks.
All networks of this type have adjancency matrices as two-dimensional arrays of
numbers.
"""
QuantitativeNetwork = Union{BipartiteQuantiNetwork, UnipartiteQuantiNetwork}

"""
All non-probabilistic networks
"""
NonProbabilisticNetwork = Union{DeterministicNetwork, QuantitativeNetwork}

"""
Return the size of the adjacency matrix of an EcoNetwork object.
"""
function Base.size(N::EcoNetwork)
    Base.size(N.A)
end

"""
Creates a copy of a network -- this returns an object with the same type, and
the same content.
"""
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

"""
Setindex for EcoNetwork
"""
function Base.setindex!(N::EcoNetwork, i...)
  return setindex!(N.A, i...)
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
