import Base.rand

"""
    rand(N::ProbabilisticNetwork)

Converts a probabilistic network into a deterministic one by performing random
draws. All interactions are treated as independent Bernoulli events. Note that
this network is *not* check for degeneracy, *i.e.* species can end up with no
interactions.
"""
function rand(N::ProbabilisticNetwork)
    # Get the correct network type
    newtype = typeof(N) <: AbstractUnipartiteNetwork ? UnipartiteNetwork : BipartiteNetwork
    return newtype(rand(size(N)).<=N.A, species_objects(N)...)
end

"""
    rand(N::ProbabilisticNetwork, n::T) where {T<:Integer}

Generates a number of random deterministic networks based on a probabilistic
network.
"""
function rand(N::ProbabilisticNetwork, n::T) where {T<:Integer}
    @assert n > 0
    return map(x -> rand(N), 1:n)
end
