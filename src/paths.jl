"""
**Number of paths of length n between all pairs of nodes**

    number_of_paths(N::Unipartite; n::Int64=2)

This returns an array, not a network.

- `n` (def. 2), the path length
"""
function number_of_paths(N::Unipartite; n::Int64=2)
  @assert n >= 2
  return N.A^n
end

"""
**Shortest paths**

    shortest_path(N::UnipartiteNetwork; nmax::Int64=50)

This is not an optimal algorithm *at all*, but it will do given that most
ecological networks are relatively small. The optional `nmax` argument is the
longest shortest path length you will look for.

In ecological networks, the longest shortest path tends not to be very long, so
any value above 10 is probably overdoing it. Note that the default value is 50,
which is above 10. But why just do, when you can overdo?
"""
function shortest_path(N::UnipartiteNetwork; nmax::Int64=50)
  # We will have a matrix of the same size at the adjacency matrix
  D = zeros(Int64, size(N))
  D[N.A] = 1
  for i in 2:nmax
    P = number_of_paths(N, n=i)
    D[(P .> 0).*(D .== 0)] = i
  end
  return D
end

"""
**Shortest paths**

    shortest_path(N::UnipartiteQuantiNetwork; nmax::Int64=50)

This function will remove quantitative information, then measure the shortest
path length.
"""
function shortest_path(N::UnipartiteQuantiNetwork; nmax::Int64=50)
  shortest_path(adjacency(N), nmax=nmax)
end
