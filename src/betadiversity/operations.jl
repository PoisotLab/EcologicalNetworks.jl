import Base.union
import Base.intersect
import Base.setdiff

function union{T<:BipartiteNetwork}(X::T, Y::T)
    new_t = union(species(X,1), species(Y,1))
    new_b = union(species(X,2), species(Y,2))
    new_a = zeros(eltype(X.A), (length(new_t), length(new_b)))
    for ti in eachindex(new_t), bi in eachindex(new_b)
        st, sb = new_t[ti], new_b[bi]
        in_x, in_y = false, false
        if st ∈ species(X,1)
            if sb ∈ species(X, 2)
                in_x = has_interaction(X, st, sb)
            end
        end
        if st ∈ species(Y,1)
            if sb ∈ species(Y, 2)
                in_y = has_interaction(Y, st, sb)
            end
        end
        new_a[ti,bi] = (in_x | in_y)
    end
    return BipartiteNetwork(new_a, new_t, new_b)
end

function intersect{T<:BipartiteNetwork}(X::T, Y::T)
    new_t = intersect(species(X,1), species(Y,1))
    new_b = intersect(species(X,2), species(Y,2))
    new_a = zeros(eltype(X.A), (length(new_t), length(new_b)))
    for ti in eachindex(new_t), bi in eachindex(new_b)
        st, sb = new_t[ti], new_b[bi]
        in_x, in_y = false, false
        in_x = has_interaction(X, st, sb)
        in_y = has_interaction(Y, st, sb)
        new_a[ti,bi] = (in_x & in_y)
    end
    return BipartiteNetwork(new_a, new_t, new_b)
end

function union{T<:UnipartiteNetwork}(X::T, Y::T)
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
        if s2 ∈ species(Y)
            if s2 ∈ species(Y)
                in_y = has_interaction(Y, s1, s2)
            end
        end
        new_a[si,sj] = (in_x | in_y)
    end
    return UnipartiteNetwork(new_a, new_s)
end

function intersect{T<:UnipartiteNetwork}(X::T, Y::T)
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

function setdiff{T<:BipartiteNetwork}(X::T, Y::T)
    new_t = setdiff(species(X,1), species(Y,1))
    new_b = setdiff(species(X,2), species(Y,2))
    return X[new_t, new_b]
end

function setdiff{T<:UnipartiteNetwork}(X::T, Y::T)
    new_s = setdiff(species(X,1), species(Y,1))
    return X[new_s]
end
