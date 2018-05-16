import Base.sum

"""
    sum(N::AbstractEcologicalNetwork)

This function will return the sum of all interactions in the network. For
quantitative networks, this is the sum of interaction strengths. For binary
networks, this is the number of interactions. For probabilistic networks, this
is the expected number of realized interactions.
"""
function sum(N::AbstractEcologicalNetwork)
   return sum(N.A)
end

"""
    links(N::BinaryNetwork)

Number of non-zero interactions in a deterministic network.
"""
function links(N::BinaryNetwork)
    return sum(N)
end

"""
    links(N::QuantitativeNetwork)

Number of non-zero interactions in a quantitative network (use `sum` to get the
sum of interaction strengths).
"""
function links(N::QuantitativeNetwork)
    return sum(N.A.>zero(eltype(N.A)))
end

"""
    links(N::ProbabilisticNetwork)

Expected number of interactions in a probabilistic network. To get the number of
interactions that have a non-zero probability, use *e.g.* `links(N>0.0)`.
"""
function links(N::ProbabilisticNetwork)
    return sum(N)
end

"""
**Variance in the expected number of links**

    links_var(N::ProbabilisticNetwork)

Expected variance of the number of links for a probabilistic network.
"""
function links_var(N::ProbabilisticNetwork)
   return sum(N.A.*(1.-N.A))
end

"""
**Connectance**

    connectance(N::AbstractEcologicalNetwork)

Number of links divided by the number of possible interactions. In unipartite
networks, this is ``L/S^2``. In bipartite networks, this is ``L/(T × B)``.
"""
function connectance(N::AbstractEcologicalNetwork)
    return links(N) / (richness(N,1)*richness(N,2))
end

"""
    connectance(N::QuantitativeNetwork)

Connectance of a quantitative network -- the information on link weight is
ignored.
"""
function connectance(N::QuantitativeNetwork)
    A = typeof(N) <: AbstractUnipartiteNetwork ? convert(UnipartiteNetwork, N) : convert(BipartiteNetwork, N)
    return connectance(A)
end

"""
    linkage_density(N::AbstractEcologicalNetwork)

Number of links divided by species richness.
"""
function linkage_density(N::AbstractEcologicalNetwork)
    return links(N) / richness(N)
end

"""
    connectance_var(N::ProbabilisticNetwork)

Expected variance of the connectance for a probabilistic matrix, measured as the
variance of the number of links divided by the squared size of the matrix.
"""
function connectance_var(N::ProbabilisticNetwork)
   return links_var(N) / (prod(size(N))^2)
end
