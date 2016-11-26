"""
For all type of networks, this is the sum of the adjacency matrix. Note that
for quantitative networks, this is the cumulative sum of link weights.
"""
function links(N::EcoNetwork)
   return sum(N.A)
end

"""
In quantitative networks only, returns the number of non-zero interactions.
"""
function link_number(N::QuantitativeNetwork)
    return sum(N.A .> 0.0)
end

"""
Expected variance of the number of links for a probabilistic network
"""
function links_var(N::ProbabilisticNetwork)
   return sum(N.A.*(1.-N.A))
end

"""
Number of links divided by the number of possible interactions. In unipartite
networks, this is ``L/S^2``. In bipartite networks, this is ``L/(T × B)``.
"""
function connectance(N::EcoNetwork)
    return links(N) / prod(size(N))
end

"""
Connectance of a quantitative network -- the information on link weight is
ignored.
"""
function connectance(N::QuantitativeNetwork)
    A = adjacency(N)
    return connectance(A)
end

"""
Linkage density

Number of links divided by species richness.
"""
function linkage_density(N::DeterministicNetwork)
    return links(N) / richness(N)
end

"""
Expected variance of the connectance for a probabilistic matrix,
measured as the variance of the number of links divided by the squared size of
the matrix.
"""
function connectance_var(N::ProbabilisticNetwork)
   return links_var(N) / (prod(size(N))^2)
end
