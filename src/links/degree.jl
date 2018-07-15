"""
**Expected number of outgoing degrees**

    degree_out(N::AbstractEcologicalNetwork)
"""
function degree_out(N::AbstractEcologicalNetwork)
  d_o = vec(sum(N.A, dims=2))
  return Dict(zip(species(N; dims=1), d_o))
end

"""
**Expected number of ingoing degrees**

    degree_in(N::AbstractEcologicalNetwork)
"""
function degree_in(N::AbstractEcologicalNetwork)
  d_i = vec(sum(N.A, dims=1))
  return Dict(zip(species(N; dims=2), d_i))
end

function degree(N::AbstractEcologicalNetwork; dims::Union{Nothing,Integer}=nothing)
  dims == 1 && return degree_out(N)
  dims == 2 && return degree_in(N)
  if dims === nothing
    if typeof(N) <: AbstractBipartiteNetwork
      return merge(degree_out(N), degree_in(N))
    else
      din = degree_in(N)
      dout = degree_out(N)
      for k in keys(din)
        din[k] += dout[k]
      end
      return din
    end
  end
  throw(ArgumentError("dims can only be 1 (out-degre) or 2 (in-degree) or `nothing` (both), you used $(dims)"))
end

function degree(N::QuantitativeNetwork; dims::Union{Nothing,Integer}=nothing)
  degree(convert(BinaryNetwork, N), dims=dims)
end

"""
**Variance in the outgoing degree**

    degree_out_var(N::ProbabilisticNetwork)
"""
function degree_out_var(N::ProbabilisticNetwork)
  d_o_v = mapslices(a_var, N.A, 2)
  return Dict(zip(species(N; dims=1), d_o_v))
end

"""
**Variance in the ingoing degree**

    degree_in_var(N::ProbabilisticNetwork)
"""
function degree_in_var(N::ProbabilisticNetwork)
  d_i_v = mapslices(a_var, N.A, 1)'
  return Dict(zip(species(N; dims=2), d_i_v))
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

function degree_var(N::ProbabilisticNetwork; dims::Union{Nothing,Integer}=nothing)
  dims ∈ [1,2] || throw(ArgumentError("dims can only be 1 (out-degre) or 2 (in-degree), you used $(dims)"))
  f = dims == 1 ? degree_out_var : degree_in_var
  return f(N)
end
