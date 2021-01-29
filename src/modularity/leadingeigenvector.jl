function _B_matrix(A)
    m = sum(sum(A; dims=1))/2.0
    kikj = sum(A; dims=1).*sum(A; dims=2)
    B = A - kikj./(2m)
    return B
end

"""
    leadingeigenvector(N::T) where {T <: AbstractUnipartiteNetwork}

Leading eigenvector community detection. Internally, this function will *mirror*
the network, making it symmetrical. It returns a tuple `(N, L)` where `N` is the
network and `L` is the partition assigned to each node. This method is
relatively efficient, and stops on its own when a partition can no longer be
divided.
"""
function leadingeigenvector(N::T) where {T <: AbstractUnipartiteNetwork}
    K = EcologicalNetworks.mirror(N)

    L = ones(Int64, richness(K))
    todo = unique(L)

    while length(todo) > 0
        this = findall(L .== last(todo))

        B = _B_matrix(K.edges[this, this])
        if all(isnan.(B))
            pop!(todo)
        else
            F = eigen(B)
            next = maximum(L)+1
            push!(todo, next)
            for (i,f) in enumerate(F.vectors[:,1])
                (f < 0) && (L[this[i]] = next)    
            end
        end
    end

    L = Dict(zip(species(N),L))
    return (N, L)
end
