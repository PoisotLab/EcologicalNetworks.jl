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

