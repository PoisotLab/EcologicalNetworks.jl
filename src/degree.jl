"""
Expected number of outgoing degrees
"""
function degree_out(N::EcoNetwork)
  return vec(sum(N.A, 2))
end

"""
Expected number of ingoing degrees
"""
function degree_in(N::EcoNetwork)
  return vec(sum(N.A, 1))
end

""" Expected degree
"""
function degree(N::Unipartite)
  return degree_in(N) .+ degree_out(N)
end

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
