import Base.union
import Base.intersect
import Base.setdiff

"""
    union(X::T, Y::T) where {T<:BipartiteNetwork}

Union of two bipartite networks -- interactions *and* species which are present
in either networks are also present in the final network.
"""
function union(X::T, Y::T) where {T<:BipartiteNetwork}
    new_t = union(species(X; dims=1), species(Y; dims=1))
    new_b = union(species(X; dims=2), species(Y; dims=2))
    new_a = spzeros(_interaction_type(X), length(new_t), length(new_b))
    for common in union(interactions(X), interactions(Y))
        new_a[common.from,common.to] = true
    end
    return BipartiteNetwork(new_a, new_t, new_b)
end

"""
    intersect(X::T, Y::T) where {T<:BipartiteNetwork}

Intersect between two bipartite networks. The resulting network has the *species
and interactions* common to both networks. This can result in species being
disconnected, if they are found in both networks but with no operations in
common.
"""
function intersect(X::T, Y::T) where {T<:BipartiteNetwork}
    new_t = intersect(species(X; dims=1), species(Y; dims=1))
    new_b = intersect(species(X; dims=2), species(Y; dims=2))
    new_a = spzeros(_interaction_type(X), length(new_t), length(new_b))
    for common in intersect(interactions(X), interactions(Y))
        new_a[common.from,common.to] = true
    end
    return BipartiteNetwork(new_a, new_t, new_b)
end

"""
    union(X::T, Y::T) where {T<:UnipartiteNetwork}

Union of two unipartite networks -- interactions *and* species which are present
in either networks are also present in the final network.
"""
function union(X::T, Y::T) where {T<:UnipartiteNetwork}
    new_s = union(species(X), species(Y))
    new_a = zeros(eltype(X.A), (length(new_s), length(new_s)))
    for si in eachindex(new_s), sj in eachindex(new_s)
        s1, s2 = new_s[si], new_s[sj]
        in_x, in_y = false, false
        if s1 ∈ species(X)
            if s2 ∈ species(X)
                in_x = has_interaction(X, s1, s2)
            end
        end
        if s1 ∈ species(Y)
            if s2 ∈ species(Y)
                in_y = has_interaction(Y, s1, s2)
            end
        end
        new_a[si,sj] = (in_x | in_y)
    end
    return UnipartiteNetwork(new_a, new_s)
end

"""
    intersect(X::T, Y::T) where {T<:UnipartiteNetwork}

Intersect between two unipartite networks. The resulting network has the
*species and interactions* common to both networks. This can result in species
being disconnected, if they are found in both networks but with no operations in
common.
"""
function intersect(X::T, Y::T) where {T<:UnipartiteNetwork}
    new_s = intersect(species(X), species(Y))
    new_a = zeros(eltype(X.A), (length(new_s), length(new_s)))
    for si in eachindex(new_s), sj in eachindex(new_s)
        s1, s2 = new_s[si], new_s[sj]
        in_x, in_y = false, false
        in_x = has_interaction(X, s1, s2)
        in_y = has_interaction(Y, s1, s2)
        new_a[si,sj] = (in_x & in_y)
    end
    return UnipartiteNetwork(new_a, new_s)
end

"""
    setdiff(X::T, Y::T) where {T<:BipartiteNetwork}

Difference between two bipartite networks. This operation is *sensitive* to the
order of arguments, as the resulting network will have the species present in
the first network (and their interactions) only.
"""
function setdiff(X::T, Y::T) where {T<:BipartiteNetwork}
    new_t = setdiff(species(X; dims=1), species(Y; dims=1))
    new_b = setdiff(species(X; dims=2), species(Y; dims=2))
    return X[new_t, new_b]
end

"""
    setdiff(X::T, Y::T) where {T<:UnipartiteNetwork}

Difference between two unipartite networks. This operation is *sensitive* to the
order of arguments, as the resulting network will have the species present in
the first network (and their interactions) only.
"""
function setdiff(X::T, Y::T) where {T<:UnipartiteNetwork}
    new_s = setdiff(species(X; dims=1), species(Y; dims=1))
    return X[new_s]
end
