""" Expected number of links for a probabilistic matrix
"""
function links(N::EcoNetwork)
   return sum(N.A)
end

""" Expected variance of the number of links for a probabilistic matrix
"""
function links_var(N::UnipartiteProbaNetwork)
   return sum(N.A.*(1.-N.A))
end

function links_var(N::BipartiteProbaNetwork)
   return sum(N.A.*(1.-N.A))
end

""" Expected connectance for a probabilistic matrix, measured as the number
of expected links, divided by the size of the matrix.
"""
function connectance(N::EcoNetwork)
   return links(N) / prod(size(N))
end

""" Expected variance of the connectance for a probabilistic matrix,
measured as the variance of the number of links divided by the squared size of
the matrix.
"""
function connectance_var(N::BipartiteProbaNetwork)
   return links_var(N) / (prod(size(N))^2)
end

function connectance_var(N::UnipartiteProbaNetwork)
   return links_var(N) / (prod(size(N))^2)
end
