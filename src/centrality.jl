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
