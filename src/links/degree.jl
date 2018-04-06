"""
**Expected number of outgoing degrees**

    degree_out(N::AbstractEcologicalNetwork)
"""
function degree_out(N::AbstractEcologicalNetwork)
  d_o = vec(sum(N.A, 2))
  return Dict(zip(species(N,1), d_o))
end

"""
**Expected number of ingoing degrees**

    degree_in(N::AbstractEcologicalNetwork)
"""
function degree_in(N::AbstractEcologicalNetwork)
  d_i = vec(sum(N.A, 1))
  return Dict(zip(species(N,2), d_i))
end

"""
**Degree of species in a unipartite network**

    degree(N::Unipartite)
"""
function degree(N::AbstractUnipartiteNetwork)
  return degree_in(N) .+ degree_out(N)
end

"""
**Degree of species in a bipartite network**

    degree(N::Bipartite)

This is a concatenation of the out degree and the in degrees of nodes on both
sizes, as measured by making the graph unipartite first. Rows are first, columns
second.
"""
function degree(N::AbstractBipartiteNetwork)
    return degree(make_unipartite(N))
end

"""
**Variance in the outgoing degree**

    degree_out_var(N::ProbabilisticNetwork)
"""
function degree_out_var(N::ProbabilisticNetwork)
  return mapslices(a_var, N.A, 2)
end

"""
**Variance in the ingoing degree**

    degree_in_var(N::ProbabilisticNetwork)
"""
function degree_in_var(N::ProbabilisticNetwork)
  return mapslices(a_var, N.A, 1)'
end

"""
**Variance in the degree**

    degree_var(N::UnipartiteProbaNetwork)
"""
function degree_var(N::UnipartiteProbabilisticNetwork)
  return degree_out_var(N) .+ degree_in_var(N)
end
