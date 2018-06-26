"""
Nestedness of a single axis (called internally by `η`)
"""
function η_axis(N::AbstractBipartiteNetwork)
  S = size(N)[1]
  n = vec(sum(N.A, 2))
  num = 0.0
  den = 0.0
  @simd for j in 2:S
    @simd for i in 1:(j-1)
      @inbounds num += sum(N[i,:].*N[j,:])
      @inbounds den += minimum([n[i], n[j]])
    end
  end
  return sum(num ./ den)
end

"""
**Nestedness η of a matrix**

    η(N::Union{BipartiteNetwork, BipartiteProbaNetwork})

This returns the nestedness of the entire matrix, of the columns, and of the
rows.
"""
function η(N::Union{BipartiteNetwork, BipartiteProbabilisticNetwork})
  n_1 = η_axis(N')
  n_2 = η_axis(N)
  n = (n_1 + n_2)/2.0
  return Dict(:network => n, :columns => n_1, :rows => n_2)
end

"""
WNODF of a single axis
"""
function nodf_axis(N::BipartiteQuantitativeNetwork)

  # Get the row order
  row_order = sortperm(vec(sum(N.A, 2)), rev=true)

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
  row_order = sortperm(vec(sum(N.A, 2)), rev=true)

  # Extract the ordered matrix as floating point values, so that all other
  # measures will work for both the quanti and deterministic networks
  A = N.A[row_order,:]
  d = float(vec(sum(A,2)))

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
    nodf(N::Union{BipartiteNetwork,BipartiteQuantiNetwork})

If the network is quantitative, then *WNODF* is measured instead of *NODF*. Note
that in *all* situations, the value goes between 0 (not nested) to 1 (perfectly
nested). This is a change with regard to the original papers, in which the
maximal value is 100. The nestedness for the entire network is returned.
"""
function nodf(N::T) where {T <: Union{BipartiteNetwork,BipartiteQuantitativeNetwork}}

  return (nodf(N,1)+nodf(N,2))/2.0
end

"""
    nodf(N::T, i::Int64)

If the network is quantitative, then *WNODF* is measured instead of *NODF*. Note
that in *all* situations, the value goes between 0 (not nested) to 1 (perfectly
nested). This is a change with regard to the original papers, in which the
maximal value is 100. The second argument can be `1` (for nestedness of rows/top
level) or `2` (for nestedness of columns/bottom level).
"""
function nodf(N::T, i::Int64) where {T <: Union{BipartiteNetwork,BipartiteQuantitativeNetwork}}

  @assert i ∈ [1,2]
  NODFval = i == 1 ? nodf_axis(N) : nodf_axis(N')
  correction = i == 1 ? (richness(N,1) * (richness(N,1) - 1)) : (richness(N,2) * (richness(N,2) - 1))

  return 2.0 * NODFval / float(correction)

end
