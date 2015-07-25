"""Nestedness of a single axis (called internally by `nestedness`)
"""
function nestedness_axis(A::Array{Float64,2}; axis::Int64=1)
    @assert axis in 1:2
    if axis == 2
        B = A
    else
        B = A'
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

"""Nestedness of a matrix, using the Bastolla et al. (XXXX) measure

Returns three values:

- nestedness of the entire matrix
- nestedness of the columns
- nestedness of the rows
"""
function nestedness(A::Array{Float64,2})
   n_1 = nestedness_axis(A, axis=1)
   n_2 = nestedness_axis(A, axis=2)
   n = (n_1 + n_2)/2.0
   return [n, n_1, n_2]
end
