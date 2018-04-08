"""
This is an abstract type that allows to generate functions for all sorts of
networks. All other types are derived from this one.
"""
abstract type AbstractEcologicalNetwork end

"""
All unipartite networks
"""
abstract type AbstractUnipartiteNetwork <: AbstractEcologicalNetwork end

"""
All bipartite networks
"""
abstract type AbstractBipartiteNetwork <: AbstractEcologicalNetwork end

"""
A bipartite deterministic network is a two-dimensional array of boolean values.
"""
struct BipartiteNetwork{NT<:Union{AbstractString,Symbol}} <: AbstractBipartiteNetwork
  A::Array{Bool,2}
  T::Array{NT,1}
  B::Array{NT,1}
end

"""
An unipartite deterministic network.
"""
struct UnipartiteNetwork{NT<:Union{AbstractString,Symbol}} <: AbstractUnipartiteNetwork
  A::Array{Bool,2}
  S::Array{NT,1}
end

struct BipartiteProbabilisticNetwork{IT<:AbstractFloat, NT<:Union{AbstractString,Symbol}} <: AbstractBipartiteNetwork
  A::Array{IT,2}
  T::Array{NT,1}
  B::Array{NT,1}
end

struct BipartiteQuantitativeNetwork{IT<:Number, NT<:Union{AbstractString,Symbol}} <: AbstractBipartiteNetwork
  A::Array{IT,2}
  T::Array{NT,1}
  B::Array{NT,1}
end

struct UnipartiteProbabilisticNetwork{IT<:AbstractFloat, NT<:Union{AbstractString,Symbol}} <: AbstractUnipartiteNetwork
  A::Array{IT,2}
  S::Array{NT,1}
end

struct UnipartiteQuantitativeNetwork{IT<:Number, NT<:Union{AbstractString,Symbol}} <: AbstractUnipartiteNetwork
  A::Array{IT,2}
  S::Array{NT,1}
end

"""
This is a union type for both Bipartite and Unipartite probabilistic networks.
Probabilistic networks are represented as arrays of floating point values ∈
[0;1].
"""
ProbabilisticNetwork = Union{BipartiteProbabilisticNetwork, UnipartiteProbabilisticNetwork}

"""
This is a union type for both Bipartite and Unipartite deterministic networks.
All networks from these class have adjacency matrices represented as arrays of
Boolean values.
"""
BinaryNetwork = Union{BipartiteNetwork, UnipartiteNetwork}

"""
This is a union type for both unipartite and bipartite quantitative networks.
All networks of this type have adjancency matrices as two-dimensional arrays of
numbers.
"""
QuantitativeNetwork = Union{BipartiteQuantitativeNetwork, UnipartiteQuantitativeNetwork}

"""
All non-probabilistic networks
"""
DeterministicNetwork = Union{BinaryNetwork, QuantitativeNetwork}
