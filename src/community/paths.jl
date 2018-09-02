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

Bellman-Ford algorithm to return the shortest / easiest paths from a source
species. Refer to the `bellman_ford` global documentation for the output format.
"""
function bellman_ford(N::T, source::K) where {T <: DeterministicNetwork, K <: AllowedSpeciesTypes}

    source ∈ species(N) || throw(ArgumentError("Species $(source) is not part of the network"))

    d = Dict([s => Inf64 for s in species(N)])

    # The dictionary for the predecessor start as empty, and this saves some
    # issues with the species types being multiple possible types
    p = Dict{K,K}()
    # We will sizehint! it for good measure, but it may not be entirely filled
    sizehint!(p, richness(N))

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
    @inbounds for i in 1:richness(N)
        i == 1 && (paths = bellman_ford(N, species(N)[i]))
        i == 1 || append!(paths, bellman_ford(N, species(N)[i]))
    end
    return paths
end

function get_adj_list(N::T, species::Array{K,1}) where {T <: DeterministicNetwork, K <: AllowedSpeciesTypes}
    adj_list = Dict{K,Array{Tuple{Float64,K}}}()
    for s in species
        adj_list[s] = []
    end
    for interaction in interactions(N)
        w = get(interaction, :strength, 1.0)
        adj_list[interaction.from] = [(w, interaction.to)]
    end
    return adj_list
end

function dijkstra(N::T) where {T <: DeterministicNetwork}
    #TODO dealing with bipartite networks

    species_of_N = species(N)
    d = Dict([(s1, s2) => Inf64 for s1 in species_of_N for s2 in species_of_N])

    adj_list = get_adj_list(N, species_of_N)

    to_check = Set{K}()
    for s in species_of_N
        d[(s,s)] = 0.0
        push!(to_check, s)
    end

    while length(to_check) > 0
        current = pop!(to_check)
        for (w, neighbor) in adj_list[current]
            # check if there is a shorter path from current to neighbor
            for s in species_of_N
                if d[(current, neighbor)] < d[(current, s)] + w
                    # path from cur to neighbor via species
                    d[(current, neighbor)] = d[(current, s)] + w
                    push!(to_check, neighbor)
                end
            end
        end
    end
    return d  #TODO right output cfr Dijkstra
end

"""
    dijkstra(N::T, source::K) where {T <: DeterministicNetwork, K <: AllowedSpeciesTypes}

Dijkstra's algorithm to return the shortest / easiest paths from a source
species. Refer to the `bellman_ford` global documentation for the output format.
"""
function dijkstra(N::T, source::K) where {T <: DeterministicNetwork, K <: AllowedSpeciesTypes}

    source ∈ species(N) || throw(ArgumentError("Species $(source) is not part of the network"))

    d = Dict([s => Inf64 for s in species(N)])

    # The dictionary for the predecessor start as empty, and this saves some
    # issues with the species types being multiple possible types
    p = Dict{K,K}()
    # We will sizehint! it for good measure, but it may not be entirely filled
    sizehint!(p, richness(N))

    d[source] = 0.0

    adj_list = get_adj_list(N, species(N))

    #to_check = PriorityQueue{K,Float64}()
    #append!(to_check, (0.0, source))

    to_check = [(0.0, source)]

    while length(to_check) > 0
        dist_source_current, current = heappop!(to_check)
        for (w, neighbor) in adj_list[current]  # scan neighbors
            dist_via_neighbor = dist_source_current + w
            if d[neighbor] > dist_via_neighbor
                d[neighbor] = dist_via_neighbor
                p[neighbor] = current
                if haskey(adj_list, neighbor)
                    heappush!(to_check, (dist_via_neighbor, neighbor))
                end
            end
        end
    end

    return [(from=source, to=k, weight=d[k]) for (k,v) in p]
end
