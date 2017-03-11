"""
**Katz's centrality**

    centrality_katz(N::Unipartite; a::Float64=0.1, k::Int64=5)

This measure can work on different path length (`k`), and give a different
weight to every subsequent connection (`a`). `k` must be at least 1 (only
immediate neighbors are considered). `a` (being a weight), must be positive.

```jldoctest
julia> N = UnipartiteNetwork(eye(5));

julia> centrality_katz(N)
5×1 Array{Float64,2}:
 0.2
 0.2
 0.2
 0.2
 0.2
```
"""
function centrality_katz(N::Unipartite; a::Float64=0.1, k::Int64=5)
	@assert a <= 1.0
	@assert a >= 0.0
	@assert k >= 1
	centr = sum(hcat(map((x) -> vec(sum((a^x).*(N.A^x),1)), [1:k;])...),2)
	return centr ./ sum(centr)
end

"""
**Closeness centrality**

    centrality_closeness(N::UnipartiteNetwork; nmax::Int64=100)

Closeness centrality is defined as:

``C_{c}(i) = \sum_j \left( \frac{d_{ij}}{n-1} \right)``

where ``d`` is a matrix containing the lengths of the shortest paths between all
pairs of species, and ``n`` is the number of species.

The function calls `shortest_path` internally -- the `nmax` argument is the
maximal path length that wil be tried.
"""
function centrality_closeness(N::UnipartiteNetwork; nmax::Int64=100)
  d = shortest_path(N, nmax=nmax)
  d[diagind(d)] = 0
  d = d ./ (richness(N)-1)
  cc = sum(d, 2)
  return cc
end
