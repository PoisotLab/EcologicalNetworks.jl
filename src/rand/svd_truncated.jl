import LinearAlgebra: svd, mul!, diagm

"""
    svd_truncated(N::BinaryNetwork; rank::Integer=3)
Given a matrix `A` of dimension `n × m`, `svd_truncated(A)` returns two matrices, `Left` and `Right`, with with dimensions respectively `n × rank` and `m × rank`, corresponding to the species representation in their RDPG space of dimension `rank`.

The singular value decomposition is computed using `LinearAlgebra`'s `svd`, obtaining

`A = U * Diagonal(S) * V = U * Diagonal(√S) * Diagonal(√S) * V`.

The truncation preserves the first `rank` columns of `U * Diagonal(√S)` and the first `rank` rows `Diagonal(√S) * V`.

We have that, `A ≃ Left * Right` (and the approximation is optimal in a specified meaning).

#### References

Dalla Riva, G.V. and Stouffer, D.B., 2016. Exploring the evolutionary signature of food webs' backbones using functional traits. Oikos, 125(4), pp.446-456. https://doi.org/10.1111/oik.02305

"""
function svd_truncated(N::BinaryNetwork, rank::Integer=3)
  U, Singular, V = svd(N.A)
  Left = similar(U)
  Right = similar(V')
  mul!(Left, U, diagm(sqrt.(Singular)))
  mul!(Right, diagm(sqrt.(Singular)), V')
  Left = Left[:,1:rank]
  Right = Right[1:rank,:]
  return Left, Right
end
