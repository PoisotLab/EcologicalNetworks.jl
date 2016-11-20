"""
Number of links

For all type of networks, this is the sum of the adjacency matrix.
"""
function links(N::EcoNetwork)
   return sum(N.A)
end

"""
Expected variance of the number of links for a probabilistic network
"""
function links_var(N::ProbabilisticNetwork)
   return sum(N.A.*(1.-N.A))
end

"""
Connectance

Number of links divided by the number of possible interactions. In unipartite
networks, this is ``L/S^2``. In bipartite networks, this is ``L/(T × B)``.
"""
function connectance(N::EcoNetwork)
   return links(N) / prod(size(N))
end

"""
Linkage density

Number of links divided by species richness.
"""
function linkage_density(N::DeterministicNetwork)
    return links(N) / richnes(N)
end

"""
Expected variance of the connectance for a probabilistic matrix,
measured as the variance of the number of links divided by the squared size of
the matrix.
"""
function connectance_var(N::ProbabilisticNetwork)
   return links_var(N) / (prod(size(N))^2)
end
