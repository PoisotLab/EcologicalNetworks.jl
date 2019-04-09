import Base: eltype

"""
All networks in the package belong to the `AbstractEcologicalNetwork` type. They
all have a field `A` to represent interactions as a *matrix*, and a number of
fields for species. See the documentation for `AbstractBipartiteNetwork` and
`AbstractUnipartiteNetwork`, as well as `AllowedSpeciesTypes` for the allowed
types for species.

Note that *all* species in a network (including both levels of a bipartite
network) *must* have the same type. For example, `["a", :b, "c"]` is not a valid
array of species, as not all its elements have the same type.
"""
abstract type AbstractEcologicalNetwork end

"""
This abstract type groups all unipartite networks, regardless of the type of
information. Unipartite networks have *a single* field for species, named `S`,
which has the same number of elements as the size of the matrix.

Any unipartite network can be declared (we'll use the example of a binary
network) either using `UnipartiteNetwork(A, S)` (assuming `A` is a matrix of
interactions and `S` is a vector of species names), or `UnipartiteNetwork(A)`,
in which case the species will be named automatically.
"""
abstract type AbstractUnipartiteNetwork <: AbstractEcologicalNetwork end

"""
This abstract type groups all bipartite networks, regardless of the type of
information. Bipartite networks have *two* fields for species, named `T` (for
top, corresponding to matrix *rows*), and `B` (for bottom, matrix *columns*).

Any bipartite network can be declared (we'll use the example of a binary
network) either using `BipartiteNetwork(A, T, B)` (assuming `A` is a matrix of
interactions and `T` and `B` are vectors of species names for the top and bottom
level), or `BipartiteNetwork(A)`, in which case the species will be named
automatically.
"""
abstract type AbstractBipartiteNetwork <: AbstractEcologicalNetwork end

"""
A bipartite deterministic network is a matrix of boolean values.
"""
mutable struct BipartiteNetwork{Bool, T} <: AbstractBipartiteNetwork
  A::Matrix{Bool}
  T::Vector{T}
  B::Vector{T}
  function BipartiteNetwork{Bool, NT}(A::M, T::Vector{NT}, B::Vector{NT}) where {M<:AbstractMatrix{Bool}, NT}
    check_bipartiteness(A, T, B)
    new{Bool,NT}(A, T, B)
  end
end

"""
An unipartite deterministic network is a matrix of boolean values.
"""
mutable struct UnipartiteNetwork{Bool, T} <: AbstractUnipartiteNetwork
  A::Matrix{Bool}
  S::Vector{T}
  function UnipartiteNetwork{Bool, NT}(A::M, S::Vector{NT}) where {M<:AbstractMatrix{Bool}, NT}
    check_unipartiteness(A, S)
    new{Bool,NT}(A, S)
  end
end

"""
A bipartite probabilistic network is a matrix of floating point numbers, all of
which must be between 0 and 1.
"""
mutable struct BipartiteProbabilisticNetwork{IT<:AbstractFloat, NT} <: AbstractBipartiteNetwork
  A::Matrix{IT}
  T::Vector{NT}
  B::Vector{NT}
  function BipartiteProbabilisticNetwork{IT, NT}(A::Matrix{IT}, T::Vector{NT}, B::Vector{NT}) where {IT<:AbstractFloat, NT}
    check_bipartiteness(A, T, B)
    check_probability_values(A)
    new{IT,NT}(A, T, B)
  end
end

"""
A bipartite quantitative network is matrix of numbers. It is assumed that the
interaction strength are *positive*.
"""
mutable struct BipartiteQuantitativeNetwork{IT<:Number, NT} <: AbstractBipartiteNetwork
  A::Matrix{IT}
  T::Vector{NT}
  B::Vector{NT}
  function BipartiteQuantitativeNetwork{IT, NT}(A::Matrix{IT}, T::Vector{NT}, B::Vector{NT}) where {IT<:Number, NT}
    check_bipartiteness(A, T, B)
    new{IT,NT}(A, T, B)
  end
end

"""
A unipartite probabilistic network is a square matrix of floating point numbers,
all of which must be between 0 and 1.
"""
mutable struct UnipartiteProbabilisticNetwork{IT<:AbstractFloat, NT} <: AbstractUnipartiteNetwork
  A::Matrix{IT}
  S::Vector{NT}
  function UnipartiteProbabilisticNetwork{IT, NT}(A::Matrix{IT}, S::Vector{NT}) where {IT<:AbstractFloat,NT}
    check_unipartiteness(A, S)
    check_probability_values(A)
    new{IT,NT}(A, S)
  end
end

"""
A unipartite quantitative network is a square matrix of numbers.
"""
mutable struct UnipartiteQuantitativeNetwork{IT<:Number, NT} <: AbstractUnipartiteNetwork
  A::Matrix{IT}
  S::Vector{NT}
  function UnipartiteQuantitativeNetwork{IT, NT}(A::Matrix{IT}, S::Vector{NT}) where {IT<:Number,NT}
    check_unipartiteness(A, S)
    new{IT,NT}(A, S)
  end
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

all_types = [
    :BipartiteNetwork, :UnipartiteNetwork,
    :BipartiteProbabilisticNetwork, :UnipartiteProbabilisticNetwork,
    :BipartiteQuantitativeNetwork, :UnipartiteQuantitativeNetwork
    ]
for T in all_types
  @eval begin
    """
        eltype(N::$($T){IT,ST}) where {IT,ST}

    Returns a tuple with the type of the interactions, and the type of the species.
    """
    function eltype(N::$T{IT,ST}) where {IT,ST}
      return (IT,ST)
    end
  end
end
