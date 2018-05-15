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
  d_t = vec(sum(N.A, 2)) .+ vec(sum(N.A, 1))
  return Dict(zip(species(N), d_t))
end

function degree(N::AbstractEcologicalNetwork, i::Integer)
  @assert i ∈ [1,2]
  f = i == 1 ? degree_out : degree_in
  return f(N)
end

function degree(N::QuantitativeNetwork, i::Integer)
  degree(convert(BinaryNetwork, N), i)
end

function degree(N::QuantitativeNetwork)
  degree(convert(BinaryNetwork, N))
end

"""
**Degree of species in a bipartite network**

    degree(N::Bipartite)

This is a concatenation of the out degree and the in degrees of nodes on both
sizes, as measured by making the graph unipartite first. Rows are first, columns
second.
"""
function degree(N::AbstractBipartiteNetwork)
    return merge(degree_in(N), degree_out(N))
end

"""
**Variance in the outgoing degree**

    degree_out_var(N::ProbabilisticNetwork)
"""
function degree_out_var(N::ProbabilisticNetwork)
  d_o_v = mapslices(a_var, N.A, 2)
  return Dict(zip(species(N,1), d_o_v))
end

"""
**Variance in the ingoing degree**

    degree_in_var(N::ProbabilisticNetwork)
"""
function degree_in_var(N::ProbabilisticNetwork)
  d_i_v = mapslices(a_var, N.A, 1)'
  return Dict(zip(species(N,2), d_i_v))
end

"""
**Variance in the degree**

    degree_var(N::UnipartiteProbaNetwork)
"""
function degree_var(N::UnipartiteProbabilisticNetwork)
  d_t_v = mapslices(a_var, N.A, 1)' .+ mapslices(a_var, N.A, 2)
  return Dict(zip(species(N), d_t_v))
end

function degree_var(N::BipartiteProbabilisticNetwork)
  return merge(degree_in(N), degree_out(N))
end

function degree_var(N::ProbabilisticNetwork, i::Integer)
  @assert i ∈ [1,2]
  f = i == 1 ? degree_out_var : degree_in_var
  return f(N)
end
