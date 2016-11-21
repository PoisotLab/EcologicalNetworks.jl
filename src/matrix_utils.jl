"""
Transforms a bipartite network into a unipartite network

Note that this function returns an asymetric unipartite network.
"""
function make_unipartite(B::Bipartite)

    # Get the richness of the total network
    S = richness(B)

    # Get the correct inner (int.) and outer (net.) types
    itype, otype = typeof(B) <: DeterministicNetwork ? (Bool, UnipartiteNetwork) : (Float64, UnipartiteProbaNetwork)

    # Build the unipartite network template
    U = zeros(itype, (S,S))

    # Modify it by adding the correct values
    U[1:size(B)[1],size(B)[1]+1:S] = B.A

    # Retun the object
    return otype(U)
end

"""
Generate a random 0/1 matrix from probabilities

Returns a matrix B of the same size as A, in which each element B(i,j)
is 1 with probability A(i,j).
"""
function make_bernoulli(N::ProbabilisticNetwork)

    # Get the correct network type
    itype = typeof(N) == UnipartiteProbaNetwork ? UnipartiteNetwork : BipartiteNetwork

    # Return the Bernoulli'ed network
    return itype(rand(size(N)) .<= N.A)
end

"""
Sets the diagonal to 0

Returns a copy of the matrix A, with  the diagonal set to 0. Will fail if
the matrix is not square.
"""
function nodiag(N::Unipartite)

    # Get the type of the internal elements according to the network type
    itype = typeof(N) == UnipartiteNetwork ? Bool : Float64

    # Return a copy of the network with the same type
    return typeof(N)(N.A .* (one(itype) .- eye(itype, size(N)[1])))
end

"""
Generate a deterministic network from a probabilistic one, using a threshold

Returns a matrix B of the same size as A, in which each element B(i,j) is 1 if
A(i,j) is > `k`. This is probably unwise to use this function since this
practice is of questionnable relevance, but it is included for the sake of
exhaustivity.

`k` must be in [0;1[.
"""
function make_threshold(N::ProbabilisticNetwork, k::Float64)

    # Check the values of k
    if (k < 0.0) | (k >= 1.0)
        throw(DomainError())
    end

    # Type of return
    itype = typeof(N) == UnipartiteProbaNetwork ? UnipartiteNetwork : BipartiteNetwork

    # Return a deterministic network
    return itype(map((x) -> x>k ? 1.0 : 0.0, N.A))
end

"""
Returns the adjacency/incidence matrix from a probability matrix

Returns a matrix B of the same size as A, in which each element B(i,j) is 1 if
A(i,j) is greater than 0.
"""
function make_binary(N::ProbabilisticNetwork)
  return make_threshold(N, 0.0)
end
