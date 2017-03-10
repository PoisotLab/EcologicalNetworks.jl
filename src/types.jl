using Base

"""
**Ecological network**

This is an abstract type that allows to generate functions for all sorts of
networks. All other types are derived from this one. This is an abstract type
only, so you cannot create an object of this type directly.

All `EcoNetwork` objects have a `NamedArray{T, 2}` filed, where `T` varies from
one type of network to the other.
"""
abstract EcoNetwork

"""
**Unipartite network**
"""
abstract Unipartite <: EcoNetwork

"""
**Bipartite network**
"""
abstract Bipartite <: EcoNetwork

"""
**Bipartite deterministic network**
"""
type BipartiteNetwork <: Bipartite
  A::NamedArray{Bool, 2}
end

"""
**Unipartite deterministic network**
"""
type UnipartiteNetwork <: Unipartite
  A::NamedArray{Bool, 2}
  UnipartiteNetwork(A) = size(A, 1) == size(A, 2) ? new(A) : error("Unequal size")
end

type BipartiteProbaNetwork <: Bipartite
  A::NamedArray{Float64, 2}
end

type UnipartiteProbaNetwork <: Unipartite
  A::NamedArray{Float64, 2}
  UnipartiteProbaNetwork(A) = size(A, 1) == size(A, 2) ? new(A) : error("Unequal size")
end

type BipartiteQuantiNetwork <: Bipartite
  A::NamedArray{Float64, 2}
end

type UnipartiteQuantiNetwork <: Unipartite
  A::NamedArray{Float64, 2}
  UnipartiteQuantiNetwork(A) = size(A, 1) == size(A, 2) ? new(A) : error("Unequal size")
end

function rename_bipartite!(B::NamedArray)
  setdimnames!(B, "top", 1)
  setdimnames!(B, "bottom", 2)
end

function rename_unipartite!(B::NamedArray)
  setdimnames!(B, "predators", 1)
  setdimnames!(B, "preys", 2)
end

function BipartiteProbaNetwork{T <: Array}(A::T)
  A = convert(NamedArray, A)
  rename_bipartite!(A)
  BipartiteProbaNetwork(A)
end

function UnipartiteProbaNetwork{T <: Array}(A::T)
  A = convert(NamedArray, A)
  rename_unipartite!(A)
  UnipartiteProbaNetwork(A)
end

function UnipartiteNetwork{T <: Array}(A::T)
  A = convert(Array{Bool, 2}, A)
  A = convert(NamedArray, A)
  rename_unipartite!(A)
  UnipartiteNetwork(A)
end

function BipartiteNetwork{T <: Array}(A::T)
  A = convert(Array{Bool, 2}, A)
  A = convert(NamedArray, A)
  rename_bipartite!(A)
  BipartiteNetwork(A)
end

function UnipartiteQuantiNetwork{T <: Array}(A::T)
  A = convert(Array{Float64, 2}, A)
  A = convert(NamedArray, A)
  rename_unipartite!(A)
  UnipartiteQuantiNetwork(A)
end

function BipartiteQuantiNetwork{T <: Array}(A::T)
  A = convert(Array{Float64, 2}, A)
  A = convert(NamedArray, A)
  rename_bipartite!(A)
  BipartiteQuantiNetwork(A)
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
  y = copy(N.A)
  return typeof(N)(y)
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
