"""
Nestedness of a single axis (called internally by `η`)
"""
function η_axis(N::AbstractBipartiteNetwork)
  S = richness(N; dims=1)
  n = vec(sum(N.A; dims=2))
  num = 0.0
  den = 0.0
  @simd for j in 2:S
    @simd for i in 1:(j-1)
      @inbounds num += sum(N[i,:].*N[j,:])
      @inbounds den += min(n[i], n[j])
    end
  end
  return sum(num ./ den)
end

"""
    η(N::T, i::Int64) where {T <: Union{BipartiteNetwork, BipartiteProbaNetwork}}

Returns the nestedness of a margin of the network, using η. The second argument
can be `1` (for nestedness of rows/top level) or `2` (for nestedness of
columns/bottom level). This function will throw an `ArgumentError` if you use an
invalid value for `i`.
"""
function η(N::T; dims::Union{Nothing,Integer}=nothing) where {T <: Union{BipartiteNetwork, BipartiteProbabilisticNetwork}}
  dims == 1 && return η_axis(N)
  dims == 2 && return η_axis(permutedims(N))
  if dims === nothing
    return (η(N; dims=1) + η(N; dims=2))/2.0
  end
  throw(ArgumentError("dims can only be 1 (nestedness of rows) or 2 (nestedness of columns), you used $(dims)"))
end

"""
WNODF of a single axis
"""
function nodf_axis(N::BipartiteQuantitativeNetwork)

  # Get the row order
  row_order = sortperm(vec(sum(N.A; dims=2)), rev=true)

  # Extract the ordered matrix as floating point values, so that all other
  # measures will work for both the quanti and deterministic networks
  A = map(Float64, N.A[row_order,:])

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

  # Get the row order
  row_order = sortperm(vec(sum(N.A; dims=2)), rev=true)

  # Extract the ordered matrix as floating point values, so that all other
  # measures will work for both the quanti and deterministic networks
  A = N.A[row_order,:]
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
    nodf(N::T) where {T <: Union{BipartiteNetwork,BipartiteQuantitativeNetwork}}

If the network is quantitative, then *WNODF* is measured instead of *NODF*. Note
that in *all* situations, the value goes between 0 (not nested) to 1 (perfectly
nested). This is a change with regard to the original papers, in which the
maximal value is 100. The nestedness for the entire network is returned.
"""
function nodf(N::T) where {T <: Union{BipartiteNetwork,BipartiteQuantitativeNetwork}}
  return (nodf(N,1)+nodf(N,2))/2.0
end

"""
    nodf(N::T, i::Int64) where {T <: Union{BipartiteNetwork,BipartiteQuantitativeNetwork}}

Returns `nodf` for a margin of the network. The `i` argument can be 1 for
top-level, 2 for bottom level, and the function will throw an `ArgumentError` if
an invalid value is used. For quantitative networks, *WNODF* is used.
"""
function nodf(N::T; dims::Union{Nothing,Integer}=nothing) where {T <: Union{BipartiteNetwork,BipartiteQuantitativeNetwork}}
  if dims == 1
    val = nodf_axis(N)
    correction = (richness(N; dims=1) * (richness(N; dims=1) - 1))
    return (val+val)/correction
  end
  if dims == 2
    val = nodf_axis(permutedims(N))
    correction = (richness(N; dims=2) * (richness(N; dims=2) - 1))
    return (val+val)/correction
  end
  if dims === nothing
    return (nodf(N; dims=1)+nodf(N; dims=2))/2.0
  end
  throw(ArgumentError("dims can only be 1 (nestedness of rows) or 2 (nestedness of columns), you used $(dims)"))
end
