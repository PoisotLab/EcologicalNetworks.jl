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
    simplify(N::T) where {T<:AbstractEcoloigcalNetwork}

Returns a new network in which species with no interactions have been removed.
"""
function simplify(N::T) where {T<:AbstractEcologicalNetwork}
    Y = copy(N)
    simplify!(Y)
    return Y
end

"""
    simplify!{T<:BipartiteNetwork}(N::T)

Returns a new network in which species with no interactions have been removed.
"""
function simplify!(N::T) where {T<:BipartiteNetwork}
    isdegenerate(N) || return nothing 
    int = interactions(N)
    from = [i.from for i in int]
    to = [i.to for i in int]
    N.T = unique(from)
    N.B = unique(to)
    I = indexin(from, N.T)
    J = indexin(to, N.B)
    N.edges = sparse(I, J, true, length(N.T), length(N.B))
    return nothing
end

"""
    simplify!{T<:BipartiteNetwork}(N::T)

Returns a new network in which species with no interactions have been removed.
"""
function simplify!(N::T) where {T<:BipartiteProbabilisticNetwork}
    isdegenerate(N) || return nothing 
    int = interactions(N)
    from = [i.from for i in int]
    to = [i.to for i in int]
    N.T = unique(from)
    N.B = unique(to)
    I = indexin(from, N.T)
    J = indexin(to, N.B)
    N.edges = sparse(I, J, [i.probability for i in int], length(N.T), length(N.B))
    return nothing
end

"""
    simplify!{T<:BipartiteNetwork}(N::T)

Returns a new network in which species with no interactions have been removed.
"""
function simplify!(N::T) where {T<:BipartiteQuantitativeNetwork}
    isdegenerate(N) || return nothing 
    int = interactions(N)
    from = [i.from for i in int]
    to = [i.to for i in int]
    N.T = unique(from)
    N.B = unique(to)
    I = indexin(from, N.T)
    J = indexin(to, N.B)
    N.edges = sparse(I, J, [i.strength for i in int], length(N.T), length(N.B))
    return nothing
end

"""
    simplify!(N::UnipartiteNetwork)

Modifies the network to drop all species without an interaction.
"""
function simplify!(N::T) where {T <: UnipartiteNetwork}
    isdegenerate(N) || return nothing
    int = interactions(N)
    from = [i.from for i in int]
    to = [i.to for i in int]
    sp = unique(vcat(from, to))
    I = indexin(from, sp)
    J = indexin(to, sp)
    V = true
    N.S = sp
    N.edges = sparse(I, J, V, length(sp), length(sp))
    return nothing
end

"""
    simplify!(N::UnipartiteNetwork)

Modifies the network to drop all species without an interaction.
"""
function simplify!(N::T) where {T <: UnipartiteProbabilisticNetwork}
    isdegenerate(N) || return nothing
    int = interactions(N)
    from = [i.from for i in int]
    to = [i.to for i in int]
    sp = unique(vcat(from, to))
    I = indexin(from, sp)
    J = indexin(to, sp)
    V = [i.probability for i in int]
    N.S = sp
    N.edges = sparse(I, J, V, length(sp), length(sp))
    return nothing
end

"""
    simplify!(N::UnipartiteNetwork)

Modifies the network to drop all species without an interaction.
"""
function simplify!(N::T) where {T <: UnipartiteQuantitativeNetwork}
    isdegenerate(N) || return nothing
    int = interactions(N)
    from = [i.from for i in int]
    to = [i.to for i in int]
    sp = unique(vcat(from, to))
    I = indexin(from, sp)
    J = indexin(to, sp)
    V = [i.strength for i in int]
    N.S = sp
    N.edges = sparse(I, J, V, length(sp), length(sp))
    return nothing
end
