"""
Nestedness of a single axis (called internally by `η`)
"""
function η_axis(N::Bipartite)
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

Using the Bastolla et al. (XXXX) measure

Returns three values:
- nestedness of the entire matrix
- nestedness of the columns
- nestedness of the rows
"""
function η(N::Union{BipartiteNetwork, BipartiteProbaNetwork})
  n_1 = η_axis(N')
  n_2 = η_axis(N)
  n = (n_1 + n_2)/2.0
  return vec([n, n_1, n_2])
end

"""
WNODF of a single axis
"""
function wnodf_axis(N::BipartiteQuantiNetwork)

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

  # Initialize the value
  NODFr = 0.0
  for i in 1:(size(A, 1)-1)
    for j in (i+1):size(A, 1)
      DFpaired = sum(A[j,:]) < sum(A[i,:]) ? 1.0 : 0.0
      Npaired = sum(A[i,:] & A[j,:]) / sum(A[j,:])
      NODFr += (DFpaired * Npaired)
    end
  end

  # Return the value
  return NODFr

end

"""
**Nestedness based on Overlap and Decreasing Fill**

    nodf(N::Union{BipartiteNetwork,BipartiteQuantiNetwork})

If the network is quantitative, then *WNODF* is measured instead of *NODF*. Note
that in *all* situations, the value goes between 0 (not nested) to 1 (perfectly
nested). This is a change with regard to the original papers, in which the
maximal value is 100. The values returned are the nestedness of the network, of
the columns, and of the rows.
"""
function nodf(N::Union{BipartiteNetwork,BipartiteQuantiNetwork})

  # Determine the inner function to use
  inner_nestedness_f = typeof(N) <: DeterministicNetwork ? nodf_axis : wnodf_axis

  NODFr = inner_nestedness_f(N)
  NODFc = inner_nestedness_f(N')

  row_pair = (nrows(N) * (nrows(N) - 1))
  col_pair = (ncols(N) * (ncols(N) - 1))

  return [
  2 * (NODFc + NODFr) / (row_pair + col_pair),
  2 * NODFc / col_pair,
  2 * NODFr / row_pair
  ]

end
