"""
Nestedness of a single axis (called internally by `η`)
"""
function η_axis(N::Bipartite; axis::Int64=1)
    @assert axis in 1:2
    if axis == 2
        B = N.A
    else
        B = N.A'
    end
    S = size(B)[1]
    n = vec(sum(B, 2))
    num = 0.0
    den = 0.0
    @simd for j in 2:S
        @simd for i in 1:(j-1)
            @inbounds num += sum(B[i,:].*B[j,:])
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
    n_1 = η_axis(N, axis=1)
    n_2 = η_axis(N, axis=2)
    n = (n_1 + n_2)/2.0
    return [n, n_1, n_2]
end

function nestedness(N::Bipartite)
    warn("nestedness is deprecated, use η instead")
    return η(N)
end
