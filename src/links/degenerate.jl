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
    d = degree(N)
    new_t = filter(s -> d[s]>0, species(N,1))
    new_b = filter(s -> d[s]>0, species(N,2))
    return N[new_t, new_b]
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
    simplify{T<:AbstractUnipartiteNetwork}(N::T)

Returns a new network in which species with no interactions have been removed.
"""
function simplify(N::T) where {T<:AbstractUnipartiteNetwork}
    d = degree(N)
    new_s = filter(s -> d[s]>0, species(N))
    return N[new_s]
end
