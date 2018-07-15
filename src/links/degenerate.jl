"""
    isdegenerate(N::AbstractEcologicalNetwork)

Networks are called degenerate if some species have no interactions, either at
all, or with any species other than themselves. This is particularly useful to
decide the networks to keep when generating samples for null models.
"""
function isdegenerate(N::AbstractEcologicalNetwork)
    return minimum(values(degree(nodiagonal(N)))) == 0.0
end

"""
    simplify{T<:AbstractBipartiteNetwork}(N::T)

Returns a new network in which species with no interactions have been removed.
"""
function simplify(N::T) where {T<:AbstractBipartiteNetwork}
    Y = copy(N)
    simplify!(Y)
    return Y
end

"""
    simplify!{T<:AbstractBipartiteNetwork}(N::T)

Returns a new network in which species with no interactions have been removed.
"""
function simplify!(N::T) where {T<:AbstractBipartiteNetwork}
    d1 = degree(N; dims=1)
    d2 = degree(N; dims=2)
    p1 = filter(i -> d1[species(N; dims=1)[i]] > zero(eltype(N)[1]), 1:richness(N; dims=1))
    p2 = filter(i -> d2[species(N; dims=2)[i]] > zero(eltype(N)[1]), 1:richness(N; dims=2))
    N.T = N.T[p1]
    N.B = N.B[p2]
    N.A = N.A[p1,p2]
end

"""
    simplify(N::AbstractUnipartiteNetwork)

Returns a new network in which species with no interactions have been removed.
"""
function simplify(N::T) where {T <: AbstractUnipartiteNetwork}
    Y = copy(N)
    simplify!(Y)
    return Y
end

"""
    simplify!(N::AbstractUnipartiteNetwork)

Modifies the network to drop all species without an interaction.
"""
function simplify!(N::T) where {T <: AbstractUnipartiteNetwork}
    d = degree(N)
    positions = filter(i -> d[species(N)[i]] > zero(eltype(N)[1]), 1:richness(N))
    N.S = N.S[positions]
    N.A = N.A[positions, positions]
end
