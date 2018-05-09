import Base.sum

"""
    sum(N::AbstractEcologicalNetwork)

This function will return the sum of all interactions in the network.
"""
function sum(N::AbstractEcologicalNetwork)
   return sum(N.A)
end

"""
    L(N::AbstractEcologicalNetwork)

Number of non-zero interactions.
"""
function L(N::BinaryNetwork)
    return sum(N)
end

function L(N::QuantitativeNetwork)
    return sum(N.A.>zero(eltype(N.A)))
end

function L(N::ProbabilisticNetwork)
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
    return L(N) / (richness(N,1)*richness(N,2))
end

"""
**Connectance of a quantitative network**

    connectance(N::QuantitativeNetwork)

Connectance of a quantitative network -- the information on link weight is
ignored.
"""
function connectance(N::QuantitativeNetwork)
    A = typeof(N) <: AbstractUnipartiteNetwork ? convert(UnipartiteNetwork, N) : convert(BipartiteNetwork, N)
    return connectance(A)
end

"""
**Linkage density**

    linkage_density(N::DeterministicNetwork)

Number of links divided by species richness.
"""
function linkage_density(N::DeterministicNetwork)
    return links(N) / richness(N)
end

"""
**Variance in the expected connectance**

    connectance_var(N::ProbabilisticNetwork)

Expected variance of the connectance for a probabilistic matrix, measured as the
variance of the number of links divided by the squared size of the matrix.
"""
function connectance_var(N::ProbabilisticNetwork)
   return links_var(N) / (prod(size(N))^2)
end
