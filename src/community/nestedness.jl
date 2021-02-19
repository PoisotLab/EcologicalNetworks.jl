"""
Nestedness of a single axis (called internally by `η`)
"""
function η_axis(N::AbstractBipartiteNetwork)
  S = richness(N; dims=1)
  n = vec(sum(N.edges; dims=2))
  num = 0.0
  den = 0.0
  for j in 2:S
    Nj = N[j,:]
    for i in 1:(j-1)
      num += sum(N[i,:].*Nj)
      den += min(n[i], n[j])
    end
  end
  return num / den
end

"""
    η(N::T, dims::Union{Nothing,Integer}=nothing) where {T <: Union{BipartiteNetwork, BipartiteProbaNetwork}}

Returns the nestedness of a margin of the network, using η. The second argument
can be `1` (for nestedness of rows/top level) or `2` (for nestedness of
columns/bottom level). Leaving it at `nothing` will measure the nestedness of
the entire network.

#### References

- Bastolla, U., Fortuna, M.A., Pascual-García, A., Ferrera, A., Luque, B.,
  Bascompte, J., 2009. The architecture of mutualistic networks minimizes
  competition and increases biodiversity. Nature 458, 1018–1020.
  https://doi.org/10.1038/nature07950

- Poisot, T., Cirtwill, A.R., Cazelles, K., Gravel, D., Fortin, M.-J., Stouffer,
  D.B., 2016. The structure of probabilistic networks. Methods in Ecology and
  Evolution 7, 303–312. https://doi.org/10.1111/2041-210X.12468
"""
function η(N::T; dims::Union{Nothing,Integer}=nothing) where {T <: Union{BipartiteNetwork, BipartiteProbabilisticNetwork}}
  dims == 1 && return η_axis(N)
  dims == 2 && return η_axis(permutedims(N))
  if isnothing(dims)
    return (η(N; dims=1) + η(N; dims=2))/2.0
  end
  throw(ArgumentError("dims can only be 1 (nestedness of rows) or 2 (nestedness of columns), you used $(dims)"))
end

"""
WNODF of a single axis
"""
function nodf_axis(N::BipartiteQuantitativeNetwork)

  # Get the row order
  row_order = sortperm(vec(sum(N.edges; dims=2)), rev=true)

  # Extract the ordered matrix as floating point values, so that all other
  # measures will work for both the quanti and deterministic networks
  A = adjacency(N)
  A = map(Float64, A[row_order,:])

  # Initialize the value
  WNODFr = 0.0
  for i in 1:(size(A, 1)-1)
    for j in (i+1):size(A, 1)
      if (sum(A[i,:]) .> sum(A[j,:]))
        Nj = sum(A[j,:] .> 0.0)
        kij = 0.0
        # The following is only applied to interactions that are non-0
        # in j, which is not really clear in the original paper
        for l in eachindex(A[i,:])
          if (A[j,l] > 0.0)
            if A[j,l] < A[i,l]
              kij += 1.0
            end
          end
        end
        WNODFr += kij/Nj
      end
    end
  end

  # Return the value
  return WNODFr

end

"""
NODF of a single axis
"""
function nodf_axis(N::BipartiteNetwork)

  # Extract the ordered matrix as floating point values, so that all other
  # measures will work for both the quanti and deterministic networks
  A = adjacency(N)
  row_order = sortperm(vec(sum(A; dims=2)), rev=true)
  A = A[row_order,:]
  d = float(vec(sum(A; dims=2)))

  # Initialize the value
  NODFr = 0.0
  for i in 1:(size(A, 1)-1)
    for j in (i+1):size(A, 1)
      DFpaired = d[j] < d[i] ? 1.0 : 0.0
      Npaired = sum(A[i,:] .& A[j,:]) / d[j]
      NODFr += (DFpaired * Npaired)
    end
  end

  # Return the value
  return NODFr
end

"""
    nodf(N::T; dims::Union{Nothing,Integer}=nothing) where {T <: Union{BipartiteNetwork,BipartiteQuantitativeNetwork}}

Returns `nodf` for a margin of the network. The `i` argument can be 1 for
top-level, 2 for bottom level, and the function will throw an `ArgumentError` if
an invalid value is used. For quantitative networks, *WNODF* is used.

#### References

Almeida-Neto, M., Guimarães, P.R., Loyola, R.D., Ulrich, W., 2008. A consistent
metric for nestedness analysis in ecological systems: reconciling concept and
measurement. Oikos 117, 1227–1239.
https://doi.org/10.1111/j.0030-1299.2008.16644.x

Almeida-Neto, M., Ulrich, W., 2011. A straightforward computational approach for
measuring nestedness using quantitative matrices. Environmental Modelling &
Software 26, 173–178. https://doi.org/10.1016/j.envsoft.2010.08.003
"""
function nodf(N::T; dims::Union{Nothing,Integer}=nothing) where {T <: Union{BipartiteNetwork,BipartiteQuantitativeNetwork}}
  if dims == 1
    val = nodf_axis(N)
    correction = (richness(N; dims=1) * (richness(N; dims=1) - 1))
    return 2val/correction
  end
  if dims == 2
    val = nodf_axis(permutedims(N))
    correction = (richness(N; dims=2) * (richness(N; dims=2) - 1))
    return 2val/correction
  end
  if isnothing(dims)
    return (nodf(N; dims=1)+nodf(N; dims=2))/2.0
  end
  throw(ArgumentError("dims can only be 1 (nestedness of rows) or 2 (nestedness of columns), you used $(dims)"))
end
