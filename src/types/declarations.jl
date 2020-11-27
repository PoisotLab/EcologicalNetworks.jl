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
mutable struct BipartiteNetwork{Bool, ST} <: AbstractBipartiteNetwork
    edges::SparseMatrixCSC{Bool,Int64}
    T::Vector{ST}
    B::Vector{ST}
    function BipartiteNetwork{Bool, NT}(edges::M, T::Vector{NT}, B::Vector{NT}) where {M<:SparseMatrixCSC, NT}
        dropzeros!(edges)
        check_bipartiteness(edges, T, B)
        new{Bool,NT}(edges, T, B)
    end
end

function BipartiteNetwork(A::M, T::Union{Vector{TT},Nothing}=nothing, B::Union{Vector{TT},Nothing}=nothing) where {M <: AbstractMatrix{Bool}, TT}
    if isnothing(B)
        B = "b".*string.(1:size(A, 2))
    else
        check_species_validity(TT)
    end
    if isnothing(T)
        T = "t".*string.(1:size(A, 1))
    else
        check_species_validity(TT)
    end
    allunique(T) || throw(ArgumentError("All top-level species must be unique"))
    allunique(B) || throw(ArgumentError("All bottom-level species must be unique"))
    allunique(vcat(B,T)) || throw(ArgumentError("Bipartite networks cannot share species across levels"))
    isequal(length(T))(size(A,1)) || throw(ArgumentError("The matrix has the wrong number of top-level species"))
    isequal(length(B))(size(A,2)) || throw(ArgumentError("The matrix has the wrong number of bottom-level species"))
    return BipartiteNetwork{Bool,eltype(T)}(sparse(A), T, B)
end

"""
An unipartite deterministic network is a matrix of boolean values.
"""
mutable struct UnipartiteNetwork{Bool, ST} <: AbstractUnipartiteNetwork
    edges::SparseMatrixCSC{Bool,Int64}
    S::Vector{ST}
    function UnipartiteNetwork{Bool, ST}(edges::M, S::Vector{ST}) where {M<:SparseMatrixCSC, ST}
        check_unipartiteness(edges, S)
        dropzeros!(edges)
        new{Bool,ST}(edges, S)
    end
end

function UnipartiteNetwork(A::M, S::Union{Vector{TT},Nothing}=nothing) where {M <: AbstractMatrix{Bool}, TT}
    if isnothing(S)
        S = "s".*string.(1:size(A, 1))
    else
        check_species_validity(TT)
    end
    allunique(S) || throw(ArgumentError("All species must be unique"))
    isequal(length(S))(size(A,1)) || throw(ArgumentError("The matrix has the wrong number of top-level species"))
    isequal(length(S))(size(A,2)) || throw(ArgumentError("The matrix has the wrong number of bottom-level species"))
    return UnipartiteNetwork{Bool,eltype(S)}(sparse(A), S)
end

"""
A bipartite probabilistic network is a matrix of floating point numbers, all of
which must be between 0 and 1.
"""
mutable struct BipartiteProbabilisticNetwork{IT <: AbstractFloat, ST} <: AbstractBipartiteNetwork
    edges::SparseMatrixCSC{IT,Int64}
    T::Vector{ST}
    B::Vector{ST}
    function BipartiteProbabilisticNetwork{IT,ST}(edges::SparseMatrixCSC{IT,Int64}, T::Vector{ST}, B::Vector{ST}) where {IT <: AbstractFloat, ST}
        dropzeros!(edges)
        check_probability_values(edges)
        new{IT,ST}(edges, T, B)
    end
end

function BipartiteProbabilisticNetwork(A::Array{IT,2}, T::Union{Vector{TT},Nothing}=nothing, B::Union{Vector{TT},Nothing}=nothing) where {IT <: AbstractFloat, TT}
    if isnothing(B)
        B = "b".*string.(1:size(A, 2))
    else
        check_species_validity(TT)
    end
    if isnothing(T)
        T = "t".*string.(1:size(A, 1))
    else
        check_species_validity(TT)
    end
    allunique(T) || throw(ArgumentError("All top-level species must be unique"))
    allunique(B) || throw(ArgumentError("All bottom-level species must be unique"))
    allunique(vcat(B,T)) || throw(ArgumentError("Bipartite networks cannot share species across levels"))
    isequal(length(T))(size(A,1)) || throw(ArgumentError("The matrix has the wrong number of top-level species"))
    isequal(length(B))(size(A,2)) || throw(ArgumentError("The matrix has the wrong number of bottom-level species"))
    return BipartiteProbabilisticNetwork(sparse(A), T, B)
end

"""
A bipartite quantitative network is matrix of numbers. It is assumed that the
interaction strength are *positive*.
"""
mutable struct BipartiteQuantitativeNetwork{IT <: Number, ST} <: AbstractBipartiteNetwork
    edges::SparseMatrixCSC{IT,Int64}
    T::Vector{ST}
    B::Vector{ST}
    function BipartiteQuantitativeNetwork{IT, NT}(edges::SparseMatrixCSC{IT,Int64}, T::Vector{NT}, B::Vector{NT}) where {IT <: Number, NT}
        dropzeros!(edges)
        new{IT,NT}(edges, T, B)
    end
end

function BipartiteQuantitativeNetwork(A::Matrix{IT}, T::Union{Vector{TT},Nothing}=nothing, B::Union{Vector{TT},Nothing}=nothing) where {IT <: Number, TT}
    if isnothing(B)
        B = "b".*string.(1:size(A, 2))
    else
        check_species_validity(TT)
    end
    if isnothing(T)
        T = "t".*string.(1:size(A, 1))
    else
        check_species_validity(TT)
    end
    allunique(T) || throw(ArgumentError("All top-level species must be unique"))
    allunique(B) || throw(ArgumentError("All bottom-level species must be unique"))
    allunique(vcat(B,T)) || throw(ArgumentError("Bipartite networks cannot share species across levels"))
    isequal(length(T))(size(A,1)) || throw(ArgumentError("The matrix has the wrong number of top-level species"))
    isequal(length(B))(size(A,2)) || throw(ArgumentError("The matrix has the wrong number of bottom-level species"))
    return BipartiteQuantitativeNetwork{IT,eltype(T)}(sparse(A), T, B)
end

"""
A unipartite probabilistic network is a square matrix of floating point numbers,
all of which must be between 0 and 1.
"""
mutable struct UnipartiteProbabilisticNetwork{IT <: AbstractFloat, ST} <: AbstractUnipartiteNetwork
    edges::SparseMatrixCSC{IT,Int64}
    S::Vector{ST}
    function UnipartiteProbabilisticNetwork{IT, NT}(edges::SparseMatrixCSC{IT,Int64}, S::Vector{NT}) where {IT <: AbstractFloat, NT}
        dropzeros!(edges)
        check_unipartiteness(edges, S)
        check_probability_values(edges)
        new{IT,NT}(edges, S)
    end
end

function UnipartiteProbabilisticNetwork(A::Matrix{IT}, S::Union{Vector{TT},Nothing}=nothing) where {IT <: AbstractFloat, TT}
    if isnothing(S)
        S = "s".*string.(1:size(A, 2))
    else
        check_species_validity(TT)
    end
    allunique(S) || throw(ArgumentError("All species must be unique"))
    isequal(length(S))(size(A,1)) || throw(ArgumentError("The matrix has the wrong number of top-level species"))
    isequal(length(S))(size(A,2)) || throw(ArgumentError("The matrix has the wrong number of bottom-level species"))
    return UnipartiteProbabilisticNetwork{IT,eltype(S)}(sparse(A), S)
end


"""
A unipartite quantitative network is a square matrix of numbers.
"""
mutable struct UnipartiteQuantitativeNetwork{IT <: Number, ST} <: AbstractUnipartiteNetwork
    edges::SparseMatrixCSC{IT,Int64}
    S::Vector{ST}
    function UnipartiteQuantitativeNetwork{IT, NT}(edges::SparseMatrixCSC{IT,Int64}, S::Vector{NT}) where {IT <: Number, NT}
        dropzeros!(edges)
        check_unipartiteness(edges, S)
        new{IT,NT}(edges, S)
    end
end

function UnipartiteQuantitativeNetwork(A::Matrix{IT}, S::Union{Vector{TT},Nothing}=nothing) where {IT <: Number, TT}
    if isnothing(S)
        S = "s".*string.(1:size(A, 2))
    else
        check_species_validity(TT)
    end
    allunique(S) || throw(ArgumentError("All species must be unique"))
    isequal(length(S))(size(A,1)) || throw(ArgumentError("The matrix has the wrong number of top-level species"))
    isequal(length(S))(size(A,2)) || throw(ArgumentError("The matrix has the wrong number of bottom-level species"))
    return UnipartiteQuantitativeNetwork{IT,eltype(S)}(sparse(A), S)
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
