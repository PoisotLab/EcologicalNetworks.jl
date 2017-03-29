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

``C_{c}(i) = \\sum_j \\left( \\frac{n-1}{d_{ji}} \\right)``

where ``\mathbf{d}`` is a matrix containing the lengths of the shortest paths
between all pairs of species, and ``n`` is the number of species.

The function calls `shortest_path` internally -- the `nmax` argument is the
maximal path length that wil be tried.
"""
function centrality_closeness(N::UnipartiteNetwork; nmax::Int64=100)
  d = shortest_path(N, nmax=nmax)
  n = richness(N)-1
  d[diagind(d)] = 0
  interm = sum(d, 2)
  interm = vec(n ./ interm)
  for i in eachindex(interm)
    interm[i] = interm[i] == Inf ? 0.0 : interm[i]
  end
  return interm
end


"""
**Degree centrality**

    centrality_degree(N::UnipartiteNetwork)

Degree centrality, corrected by the maximum degree (the most central species has
a degree of 1).

``C_{d}(i) = k_i / \\text{max}(\\mathbf{k})``

"""
function centrality_degree(N::UnipartiteNetwork)
  d = degree(N)
  return d ./ maximum(d)
end
