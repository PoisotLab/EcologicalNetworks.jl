"""
**Expected number of outgoing degrees**

    degree_out(N::AbstractEcologicalNetwork)
"""
function degree_out(N::AbstractEcologicalNetwork)
  d_o = vec(sum(N.A, dims=2))
  return Dict(zip(species(N, dims=1), d_o))
end

"""
**Expected number of ingoing degrees**

    degree_in(N::AbstractEcologicalNetwork)
"""
function degree_in(N::AbstractEcologicalNetwork)
  d_i = vec(sum(N.A, dims=1))
  return Dict(zip(species(N, dims=2), d_i))
end

"""
**Degree of species in a unipartite network**

    degree(N::Unipartite)
"""
function degree(N::AbstractUnipartiteNetwork)
  d_t = vec(sum(N.A, dims=2)) .+ vec(sum(N.A, dims=1))
  return Dict(zip(species(N), d_t))
end

function degree(N::AbstractEcologicalNetwork; dims::Integer=1)
  dims == 1 && return degree_out(N)
  dims == 2 && return degree_in(N)
  throw(ArgumentError("dims can only be 1 (out-degre) or 2 (in-degree), you used $(dims)"))
end

function degree(N::QuantitativeNetwork; dims::Integer=1)
  degree(convert(BinaryNetwork, N), dims=dims)
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

function degree_var(N::ProbabilisticNetwork; dims::Integer=1)
  dims ∈ [1,2] || throw(ArgumentError("dims can only be 1 (out-degre) or 2 (in-degree), you used $(dims)"))
  f = dims == 1 ? degree_out_var : degree_in_var
  return f(N)
end
