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
Nestedness of a matrix, using the Bastolla et al. (XXXX) measure

Returns three values:

- nestedness of the entire matrix
- nestedness of the columns
- nestedness of the rows
"""
function η(N::Bipartite)
    n_1 = η_axis(N')
    n_2 = η_axis(N)
    n = (n_1 + n_2)/2.0
    return vec([n, n_1, n_2])
end



"""
NODF of a single axis
"""
function nodf_axis(N::Union{BipartiteNetwork,BipartiteQuantiNetwork})

    # Get the row order
    row_order = sortperm(vec(sum(N.A, 2)))

    # Extract the ordered matrix as floating point values, so that all other
    # measures will work for both the quanti and deterministic networks
    A = map(Float64, N.A[row_order,:])

    # Initialize the value
    WNODFr = 0.0
    for i in 1:(size(A, 1))
        for j in (i+1):size(A, 1)
            Nj = sum(A[j,:] .> 0.0)
            kij = sum(A[j,:] .< A[i,:])
            WNODFr += kij/Nj
        end
    end

    # Return the value
    return WNODFr

end

"""
Measures the Nestedness based on Overlap and Decreasing Fill. If the network is
quantitative, then *WNODF* is measured instead of *NODF*. Note that in *all*
situations, the value goes between 0 (not nested) to 1 (perfectly nested). This
is a change with regard to the original papers, in which the maximal value is
100. The values returned are the nestedness of the network, of the columns, and
of the rows.
"""
function nodf(N::Union{BipartiteNetwork,BipartiteQuantiNetwork})

    WNODFr = nodf_axis(N)
    WNODFc = nodf_axis(N')

    row_pair = (nrows(N) * (nrows(N) - 1)) / 2
    col_pair = (ncols(N) * (ncols(N) - 1)) / 2

    return [
            2 * (WNODFc + WNODFr) / (row_pair + col_pair),
            WNODFc / col_pair,
            WNODFr / row_pair
            ]

end
