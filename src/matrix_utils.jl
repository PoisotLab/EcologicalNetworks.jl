"""Transforms a bipartite network into a unipartite network

Note that this function returns an asymetric unipartite network.
"""
function make_unipartite(B::Bipartite)

    # Get the richness of the total network
    S = richness(B)

    # Get the correct inner (int.) and outer (net.) types
    itype, otype = typeof(B) == BipartiteNetwork ? (Int64, BipartiteNetwork) : (Float64, BipartiteProbaNetwork)

    # Build the unipartite network template
    U = zeros(itype, (S,S))

    # Modify it by adding the correct values
    U[1:size(A)[1],size(A)[1]+1:S] = B.A

    # Retun the object
    return otype(U)
end

"""Generate a random 0/1 matrix from probabilities

Returns a matrix B of the same size as A, in which each element B(i,j) is 1 with
probability A(i,j).
"""
function make_bernoulli(A::Array{Float64,2})
    return map(Float64, rand(size(A)) .<= A)
end

#=
Sets the diagonal to 0
=#
"""Sets the diagonal to 0

Returns a copy of the matrix A, with  the diagonal set to 0. Will fail if the
matrix is not square.
"""
function nodiag(A::Array{Float64,2})
  # The diagonal is only relevant for square matrices
  @assert size(A)[1] == size(A)[2]
  return A .* (1.0 .- eye(Float64, size(A)[1]))
end

#=
Use a threshold
=#
"""Generate a random 0/1 matrix from probabilities

Returns a matrix B of the same size as A, in which each element B(i,j) is 1 if
A(i,j) is > `k`. This is probably unwise to use this function since this
practice is of questionnable relevance, but it is included for the sake of
exhaustivity.

`k` must be in [0;1[.
"""
function make_threshold(A::Array{Float64,2}, k::Float64)
  # Check the values of k
  if (k < 0.0) | (k >= 1.0)
    throw(DomainError())
  end
  # Return if not
  return map((x) -> x>k ? 1.0 : 0.0, A)
end

#=
Set all probabilities to 1.0
=#
"""Returns the adjacency/incidence matrix from a probability matrix

Returns a matrix B of the same size as A, in which each element B(i,j) is 1 if
A(i,j) is greater than 0.
"""
function make_binary(A::Array{Float64,2})
  return make_threshold(A, 0.0)
end
