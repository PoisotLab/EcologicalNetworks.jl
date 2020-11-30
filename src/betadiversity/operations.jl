"""
    union(X::T, Y::T) where {T<:BipartiteNetwork}

Union of two bipartite networks -- interactions *and* species which are present
in either networks are also present in the final network.
"""
function Base.union(X::T, Y::T) where {T<:BipartiteNetwork}
    new_t = union(species(X; dims=1), species(Y; dims=1))
    new_b = union(species(X; dims=2), species(Y; dims=2))
    int = interactions(X) ∪ interactions(Y)
    I = zeros(Int64, length(int))
    J = zeros(Int64, length(int))
    for i in eachindex(int)
        I[i] = findfirst(isequal(int[i].from), new_t)
        J[i] = findfirst(isequal(int[i].to), new_b)
    end
    new_a = sparse(I, J, true, length(new_t), length(new_b))
    return BipartiteNetwork(new_a, new_t, new_b)
end

"""
    intersect(X::T, Y::T) where {T<:BipartiteNetwork}

Intersect between two bipartite networks. The resulting network has the *species
and interactions* common to both networks. This can result in species being
disconnected, if they are found in both networks but with no operations in
common.
"""
function Base.intersect(X::T, Y::T) where {T<:BipartiteNetwork}
    new_t = intersect(species(X; dims=1), species(Y; dims=1))
    new_b = intersect(species(X; dims=2), species(Y; dims=2))
    I = zeros(Int64, length(int))
    J = zeros(Int64, length(int))
    for i in eachindex(int)
        I[i] = findfirst(isequal(int[i].from), new_t)
        J[i] = findfirst(isequal(int[i].to), new_b)
    end
    new_a = sparse(I, J, true, length(new_t), length(new_b))
    return BipartiteNetwork(new_a, new_t, new_b)
end

"""
    union(X::T, Y::T) where {T<:UnipartiteNetwork}

Union of two unipartite networks -- interactions *and* species which are present
in either networks are also present in the final network.
"""
function Base.union(X::T, Y::T) where {T<:UnipartiteNetwork}
    new_s = union(species(X), species(Y))
    int = interactions(X) ∪ interactions(Y)
    I = zeros(Int64, length(int))
    J = zeros(Int64, length(int))
    for i in eachindex(int)
        I[i] = findfirst(isequal(int[i].from), new_s)
        J[i] = findfirst(isequal(int[i].to), new_s)
    end
    new_a = sparse(I, J, true, length(new_s), length(new_s))
    return UnipartiteNetwork(new_a, new_s)
end

"""
    intersect(X::T, Y::T) where {T<:UnipartiteNetwork}

Intersect between two unipartite networks. The resulting network has the
*species and interactions* common to both networks. This can result in species
being disconnected, if they are found in both networks but with no operations in
common.
"""
function Base.intersect(X::T, Y::T) where {T<:UnipartiteNetwork}
    new_s = intersect(species(X), species(Y))
    int = interactions(X) ∩ interactions(Y)
    I = zeros(Int64, length(int))
    J = zeros(Int64, length(int))
    for i in eachindex(int)
        I[i] = findfirst(isequal(int[i].from), new_s)
        J[i] = findfirst(isequal(int[i].to), new_s)
    end
    new_a = sparse(I, J, true, length(new_s), length(new_s))
    return UnipartiteNetwork(new_a, new_s)
end

"""
    setdiff(X::T, Y::T) where {T<:BipartiteNetwork}

Difference between two bipartite networks. This operation is *sensitive* to the
order of arguments, as the resulting network will have the species present in
the first network (and their interactions) only.
"""
function Base.setdiff(X::T, Y::T) where {T<:BipartiteNetwork}
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
function Base.setdiff(X::T, Y::T) where {T<:UnipartiteNetwork}
    new_s = setdiff(species(X; dims=1), species(Y; dims=1))
    return X[new_s]
end
