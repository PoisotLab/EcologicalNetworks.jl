"""
Number of paths of length n between all pairs of nodes

This returns an array, not a network.

**Keyword arguments**

- `n` (def. 2), the path length
"""
function number_of_paths(N::Unipartite; n::Int64=2)
  @assert n >= 2
  P = N.A^n
  return P
end
