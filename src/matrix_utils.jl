"""
Transforms a bipartite network into a unipartite network. Note that this
function returns an asymetric unipartite network.
"""
function make_unipartite(B::Bipartite)

    # Get the richness of the total network
    S = richness(B)

    # Get the correct inner (int.) and outer (net.) types
    if typeof(B) <: DeterministicNetwork
        itype, otype = Bool, UnipartiteNetwork
    elseif typeof(B) <: ProbabilisticNetwork
        itype, otype = Float64, UnipartiteProbaNetwork
    elseif typeof(B) <: QuantitativeNetwork
        itype, otype = typeof(B.A[1,1]), UnipartiteQuantiNetwork
    end

    # Build the unipartite network template
    U = zeros(itype, (S,S))

    # Modify it by adding the correct values
    U[1:size(B)[1],size(B)[1]+1:S] = B.A

    # Retun the object
    return otype(U)
end

"""
Returns the adjaceny matrix of a non-deterministic network as a deterministic
network.
"""
function adjacency(N::EcoNetwork)
    t = typeof(N)
    if t <: DeterministicNetwork
        return copy(N)
    end
    otype = t <: Bipartite ? BipartiteNetwork : UnipartiteNetwork
    return otype(N.A .> 0.0)
end

"""
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
Returns a copy of the network with all diagonal elements set to the the
appropriate zero value. This means `false` for deterministic networks, and 0.0
for all other networks.
"""
function nodiag(N::Unipartite)

  Y = copy(N)
  Y.A[diagind(Y.A)] = typeof(N) == UnipartiteNetwork ? false : 0.0
  # Return a copy of the network with the same type
  return Y
end

"""
Return a copy of a bipartite network with all diagonal elements set to the
appropriate zero. You may yell "This is stupid, the diagonal means nothing in a
bipartite network, and it's also unlikely that they will be square anyways.
Morons." Well, this is rude. This function will return the network *unchanged*.

"Then why do you need this function in the first place?". We're glad you asked.
Some functions work better if the networks have no diagonal elements, and it's
better to have a function that does nothing, than a series of ifelses in these
functions.

Also, we can read your thoughts. Always.
"""
function nodiag(N::Bipartite)
  return copy(N)
end

"""
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
Returns a matrix B of the same size as A, in which each element B(i,j) is 1 if
A(i,j) is greater than 0.
"""
function make_binary(N::ProbabilisticNetwork)
  return make_threshold(N, 0.0)
end
