"""
    number_of_paths(N::Unipartite; n::Int64=2)

This returns an array, not a network.

- `n` (def. 2), the path length
"""
function number_of_paths(N::AbstractUnipartiteNetwork; n::Int64=2)
  @assert n >= 2
  return N.A^n
end

function number_of_paths(N::UnipartiteQuantitativeNetwork; n::Int64=2)
  number_of_paths(convert(UnipartiteNetwork, N); n=n)
end

"""
    shortest_path(N::UnipartiteNetwork; nmax::Int64=50)

This is not an optimal algorithm *at all*, but it will do given that most
ecological networks are relatively small. The optional `nmax` argument is the
longest shortest path length you will look for.

In ecological networks, the longest shortest path tends not to be very long, so
any value above 10 is probably overdoing it. Note that the default value is 50,
which is above 10.
"""
function shortest_path(N::UnipartiteNetwork; nmax::Int64=50)
  # We will have a matrix of the same size at the adjacency matrix
  D = zeros(Int64, size(N))
  D[N.A] .= 1
  for i in 2:nmax
    P = number_of_paths(N, n=i)
    D[(P .> 0).*(D .== 0)] .= i
  end
  return D
end

"""
    shortest_path(N::UnipartiteQuantiNetwork; nmax::Int64=50)

This function will remove quantitative information, then measure the shortest
path length.
"""
function shortest_path(N::UnipartiteQuantitativeNetwork; nmax::Int64=50)
  shortest_path(convert(UnipartiteNetwork, N); nmax=nmax)
end

"""
    bellman_ford(N::T, source::K) where {T <: DeterministicNetwork, K <: AllowedSpeciesTypes}

Bellman-ford algorithm to return the shortest / easiest paths from a source
species. Refer to the `bellman_ford` global documentation for the output format.
"""
function bellman_ford(N::T, source::K) where {T <: DeterministicNetwork, K <: AllowedSpeciesTypes}

    source ∈ species(N) || throw(ArgumentError("Species $(source) is not part of the network"))

    d = Dict([s => Inf64 for s in species(N)])
    # TODO This should be #undefined since the species type can be whatever
    p = Dict([s => "" for s in species(N)])

    d[source] = 0.0

    all_edges = interactions(N)

    for i in 1:(richness(N)-1)
        for interaction in all_edges
            w = get(interaction, :strength, 1.0)
            if d[interaction.to] > (d[interaction.from] + w)
                d[interaction.to] = d[interaction.from] + w
                p[interaction.to] = interaction.from
            end
        end
    end

    filter!(x -> x.second != "", p)
    return [(from=source, to=k, weight=d[k]) for (k,v) in p]

end


"""
    bellman_ford(N::T) where {T <: DeterministicNetwork}

Bellman-ford algorithm to return the shortest / easiest paths between all pairs
of species in the networks, as long as paths exists. This function will return a
tuple, with fields `from`, `to` and `weight`. The number of elements in the
tuple is the number of paths. This function works with quantitative and binary
networks, and assumes that no interactions are negative.

Currently, the Bellman-Ford algorithm is *slower* than the `shortest_path`
function, but the arguments are returned in a more usable way. Note that the
speed penalty is only valid when measuring the shortest paths in the entire
network (and will be fixed relatively soon), and does not apply as much for the
shortest paths from a single source node.
"""
function bellman_ford(N::T) where {T <: DeterministicNetwork}
    global paths
    for i in 1:richness(N)
        i == 1 && (paths = bellman_ford(N, species(N)[i]))
        i == 1 || append!(paths, bellman_ford(N, species(N)[i]))
    end
    return paths
end
