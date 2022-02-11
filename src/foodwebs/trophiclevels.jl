"""
    trophic_level(N::UnipartiteNetwork; f=maximum)

Returns the trophic level (from Christensen & Pauly 1992) of every species
in the food web. Primary producers have a trophic level of 1, after that,
it's complicated (see *e.g.* Williams & Martinez 2004, Thompson et al. 2007).

Post (2002) notes that the trophic level can be obtained from the maximum,
mean, or minimum distance to a producer. Given that consumers may be connected
to more than one producer, one might argue that the *mode* of this distribution
is also relevant.

In favor of the minimum, one can argue that most energy transfer should happen
along short chains; but imagining a consumer atop a chain of length 5, also
connected directly to a producer, the minimum would give it a trophic level
of 2, hiding its position at the top of the food web.

In favor of the maximum, one can argue that the higher chains give a better
idea of how far energy coming from the bottom of the food web can go. This
is a strong indication of how *vertically* diverse it is.

In this package, the keyword `f` defaults to `maximum`. Using any other
function, as long as it accepts an array (of chain distances) and return a
scalar, will work; `minimum` and `Statistics.mean` are natural alternatives,
as is `StatsBase.mode` or `Statistics.median`.

The chain length from any species to any producer is taken as the shortest
possible path between these two species, as identified by the Dijkstra
algorithm.
"""
function trophic_level(N::T; f=maximum) where {T<:UnipartiteNetwork}
    Y = nodiagonal(N)
    paths = dijkstra(Y)
    consumers = collect(keys(filter(p -> iszero(p.second), degree(Y; dims=1))))
    filter!(int -> int.to ∈ consumers, paths)
    tl = Dict{eltype(species(Y)),Float64}()
    for sp in species(Y)
        sp_paths = filter(int -> isequal(sp)(int.from), paths)
        chain_lengths = [int.weight for int in sp_paths]
        tl[sp] = isempty(chain_lengths) ? 1.0 : f(chain_lengths) + 1.0
    end
    return tl
end

"""
    fractional_trophic_level(N::UnipartiteNetwork; kwargs...)

Returns the *fractional* trophic level (after Odum & Heald 1975)
of species in a binary unipartite network. The trophic level is
calculated after Pauly & Christensen (1995), specifically as TLᵢ = 1 +
∑ⱼ(TLⱼ×DCᵢⱼ)/∑ⱼ(DCᵢⱼ), wherein TLᵢ is the trophic level
of species i, and DCᵢⱼ is the proportion of species j in the diet of
species i. Note that this function is calculated on a network where the
diagonal (i.e. self loops) are removed.

This function uses a *pseudo*-inverse to solve the linear system described
above.
"""
function fractional_trophic_level(N::UnipartiteNetwork)
    # Get the degree as a vector, ordered the same way as species
    kout = EcologicalNetworks.degree_out(N)
    𝐤 = [kout[s] for s in species(N)]
    # Adjacency matrix to solve the TL
    𝐀 = adjacency(N)
    # Diet matrix
    𝐃 = .-(𝐀 ./ 𝐤)
    replace!(𝐃, NaN => -0.0)
    𝐃[diagind(𝐃)] .= 1.0 .- 𝐃[diagind(𝐃)]
    # Solve with the inverse matrix
    𝐛 = ones(eltype(𝐃), richness(N))
    return Dict(zip(species(N), pinv(𝐃) * 𝐛))
end
