""" Measures the expected number of paths in a probabilistic network

**Keyword arguments**

- `n` (def. 2), the path length
"""
function number_of_paths(A::Array{Float64,2}; n::Int64=2)
  @assert size(A)[1] == size(A)[2]
  @assert n >= 2
  P = A^n
  return P
end
