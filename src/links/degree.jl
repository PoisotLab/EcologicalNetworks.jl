"""
    degree_out(N::AbstractEcologicalNetwork)
"""
function degree_out(N::AbstractEcologicalNetwork)
  d_o = vec(sum(N.A, dims=2))
  return Dict(zip(species(N; dims=1), d_o))
end

"""
    degree_in(N::AbstractEcologicalNetwork)
"""
function degree_in(N::AbstractEcologicalNetwork)
  d_i = vec(sum(N.A, dims=1))
  return Dict(zip(species(N; dims=2), d_i))
end

"""
    degree(N::AbstractEcologicalNetwork; dims::Union{Nothing,Integer}=nothing)

Returns the degrees of nodes in a network; `dims` can be `1` for out degree, or
`2` for in degree.

#### References

Delmas, E., Besson, M., Brice, M.-H., Burkle, L.A., Dalla Riva, G.V., Fortin,
M.-J., Gravel, D., Guimarães, P.R., Hembry, D.H., Newman, E.A., Olesen, J.M.,
Pires, M.M., Yeakel, J.D., Poisot, T., 2018. Analysing ecological networks of
species interactions. Biological Reviews 112540.
https://doi.org/10.1111/brv.12433

Poisot, T., Cirtwill, A.R., Cazelles, K., Gravel, D., Fortin, M.-J., Stouffer,
D.B., 2016. The structure of probabilistic networks. Methods in Ecology and
Evolution 7, 303–312. https://doi.org/10.1111/2041-210X.12468

Williams, R.J., 2011. Biology, Methodology or Chance? The Degree Distributions
of Bipartite Ecological Networks. PLoS One 6, e17645.
https://doi.org/10.1371/journal.pone.0017645
"""
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
  d_o_v = mapslices(a_var, N.A; dims=2)
  return Dict(zip(species(N; dims=1), d_o_v))
end

"""
**Variance in the ingoing degree**

    degree_in_var(N::ProbabilisticNetwork)
"""
function degree_in_var(N::ProbabilisticNetwork)
  d_i_v = mapslices(a_var, N.A; dims=1)'
  return Dict(zip(species(N; dims=2), d_i_v))
end

"""
    degree_var(N::ProbabilisticNetwork; dims::Union{Nothing,Integer}=nothing)

Variance in the degree of species in a probabilistic network.
"""
function degree_var(N::ProbabilisticNetwork; dims::Union{Nothing,Integer}=nothing)
  dims == 1 && return degree_out_var(N)
  dims == 2 && return degree_in_var(N)
  if dims === nothing
    if typeof(N) <: AbstractBipartiteNetwork
      return merge(degree_out_var(N), degree_in_var(N))
    else
      din = degree_in_var(N)
      dout = degree_out_var(N)
      for k in keys(din)
        din[k] += dout[k]
      end
      return din
    end
  end
  throw(ArgumentError("dims can only be 1 (out-degre) or 2 (in-degree) or `nothing` (both), you used $(dims)"))
end
