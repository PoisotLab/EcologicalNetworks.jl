"""
Measures Katz's centrality for each node in a unipartite network.

**Keyword arguments**

- `a` (def. 0.1), the weight of each subsequent connection
- `k` (def. 5), the maximal path length considered
"""
function centrality_katz(N::Unipartite; a::Float64=0.1, k::Int64=5)
	@assert size(A)[1] == size(A)[2]
	@assert a <= 1.0
	@assert a >= 0.0
	@assert k >= 1
	centr = sum(hcat(map((x) -> vec(sum((a^x).*(A^x),1)), [1:k;])...),2)
	return centr ./ sum(centr)
end
