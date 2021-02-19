import LinearAlgebra: svd, mul!, diagm

"""
    LinearAlgebra.svd(N::T) where {T <: AbstractEcologicalNetwork}

SVD of a network (i.e. SVD of the adjacency matrix)
"""
LinearAlgebra.svd(N::T) where {T <: AbstractEcologicalNetwork} = svd(adjacency(N))

"""
    svd_truncated(N::BinaryNetwork, rnk::Integer=3)

Given a binary network `N` which adjacency matrix `A` is of dimension `n × m`,
`svd_truncated(A)` returns two matrices, `Left` and `Right`, with dimensions
respectively `n × rank` and `rank × m`, corresponding to the species
representation in the network `N`'s RDPG space of rank `rank`.

The singular value decomposition is computed using `LinearAlgebra`'s `svd`,
obtaining

`A = U * Diagonal(S) * V = U * Diagonal(√S) * Diagonal(√S) * V`.

The truncation preserves the first `rank` columns of `U * Diagonal(√S)` and the
first `rank` rows `Diagonal(√S) * V`.

We have that, `A ≃ Left * Right` (and the approximation is optimal in a
specified meaning).

#### References

Dalla Riva, G.V. and Stouffer, D.B., 2016. Exploring the evolutionary signature
of food webs' backbones using functional traits. Oikos, 125(4), pp.446-456.
https://doi.org/10.1111/oik.02305

"""
function rdpg(N::T, rnk::Integer=3) where {T<:BinaryNetwork}
    U, singular_values, V = svd(N)
    left_space = similar(U)
    right_space = similar(V')
    mul!(left_space, U, diagm(sqrt.(singular_values)))
    mul!(right_space, diagm(sqrt.(singular_values)), V')
    left_space = left_space[:,1:rnk]
    right_space = right_space[1:rnk,:]
    return left_space, right_space
end
