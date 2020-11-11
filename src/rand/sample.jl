import StatsBase: sample

"""
    sample(N::T, n::Int64) where {T<:AbstractUnipartiteNetwork}

Samples a sub-network from a unipartite network. `n` is the number of species to
have in the sampled network. This functions makes *no* attempt to ensure that
the network is not degenerate, or even has a single interaction. This is the
recommended way to sample a unipartite network.
"""
function sample(N::T, n::Int64) where {T<:AbstractUnipartiteNetwork}
    @assert n <= richness(N)
    ns = StatsBase.sample(species(N), n, replace=false)
    return N[ns]
end

"""
    sample(N::T, n::Tuple{Int64}) where {T<:AbstractUnipartiteNetwork}

Same as `sample`, but work when called with `(n,)` instead of a species number.
This is an accepted way to sample a unipartite network.
"""
function sample(N::T, n::Tuple{Int64}) where {T<:AbstractUnipartiteNetwork}
    return sample(N, n[1])
end

"""
    sample(N::T, n::Tuple{Int64,Int64}) where {T<:AbstractUnipartiteNetwork}

Same as `sample` but called with `(n,n)` instead of a species number. Note that
this will fail if the size requested is not square. This is not a really good
way to sample a unipartite network.
"""
function sample(N::T, n::Tuple{Int64,Int64}) where {T<:AbstractUnipartiteNetwork}
    @assert first(n) == last(n)
    return sample(N, n[1])
end

"""
    sample(N::T, n::Tuple{Int64}) where {T<:AbstractBipartiteNetwork}

Same as `sample` but with a single species number given as `(n,)`, to return a
bipartite network of equal richness on both sides. This is not a very good way
to sample a bipartite network.
"""
function sample(N::T, n::Tuple{Int64}) where {T<:AbstractBipartiteNetwork}
    @assert n[1] <= richness(N; dims=1)
    @assert n[1] <= richness(N; dims=2)
    return sample(N, (n[1],n[1]))
end

"""
    sample(N::T, n::Int64) where {T<:AbstractBipartiteNetwork}

Same thing as `sample` but with a single species number, to return a bipartite
network of equal richness on both sides. This is not a very good way to sample a
bipartite network.
"""
function sample(N::T, n::Int64) where {T<:AbstractBipartiteNetwork}
    @assert n <= richness(N; dims=1)
    @assert n <= richness(N; dims=2)
    return sample(N, (n,n))
end

"""
    sample(N::T, n::Tuple{Int64,Int64}) where {T<:AbstractBipartiteNetwork}

Samples a sub-network from a bipartite network. `n` is the size of the network
to return, *i.e.* number of top and bottom species. This functions makes *no*
attempt to ensure that the network is not degenerate, or even has a single
interaction.

This is the recommended way to sample a bipartite network.
"""
function sample(N::T, n::Tuple{Int64,Int64}) where {T<:AbstractBipartiteNetwork}
    @assert n[1] <= richness(N; dims=1)
    @assert n[2] <= richness(N; dims=2)
    ns1 = StatsBase.sample(species(N; dims=1), n[1], replace=false)
    ns2 = StatsBase.sample(species(N; dims=2), n[2], replace=false)
    return N[ns1,ns2]
end
