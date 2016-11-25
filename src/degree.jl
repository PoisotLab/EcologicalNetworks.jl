"""
Expected number of outgoing degrees (generality sensu Scheiner).
"""
function degree_out(N::EcoNetwork)
  return vec(sum(N.A, 2))
end

"""
Expected number of ingoing degrees (vulnerability sensu Scheiner).
"""
function degree_in(N::EcoNetwork)
  return vec(sum(N.A, 1))
end

"""
This function returns the sum of the in and out degree of a unipartite graph
"""
function degree(N::Unipartite)
  return degree_in(N) .+ degree_out(N)
end

"""
This function returns the total degree of nodes in a bipartite network. This
is a concatenation of the out degree and the in degrees of nodes on both sizes
"""
function degree(N::Bipartite)
    return degree(make_unipartite(N))
end

function degree_out_var(N::ProbabilisticNetwork)
  return mapslices(a_var, N.A, 2)
end

function degree_in_var(N::ProbabilisticNetwork)
  return mapslices(a_var, N.A, 1)'
end

function degree_var(N::UnipartiteProbaNetwork)
  return degree_out_var(N) .+ degree_in_var(N)
end
