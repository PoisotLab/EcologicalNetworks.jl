"""
    PreferentialAttachment
"""
mutable struct PreferentialAttachment{T<:Integer} <: NetworkGenerator
    size::Tuple{T,T}
    numedges::Integer
end

PreferentialAttachment(;
    size::T = 30,
    connectance::FT = 0.3,
) where {T<:Union{Tuple{Integer},Integer},FT<:AbstractFloat} =
    PreferentialAttachment(size, connectance)

PreferentialAttachment(sz::T, X::NT) where {T<:Integer,NT<:Number} =
    PreferentialAttachment((sz, sz), X)
PreferentialAttachment(sz::T, E::ET) where {T<:Tuple{Integer,Integer},ET<:Integer} =
    PreferentialAttachment(sz, E)
PreferentialAttachment(sz::T, C::CT) where {T<:Tuple{Integer,Integer},CT<:AbstractFloat} =
    PreferentialAttachment(sz, Int(floor(C * sz[1] * sz[2])))

_generate!(gen::PreferentialAttachment, ::Type{T}) where {T<:BipartiteNetwork} =
    bipartite_preferentialattachment(size(gen)..., gen.numedges)
_generate!(gen::PreferentialAttachment, ::Type{T}) where {T<:UnipartiteNetwork} =
    unipartite_preferentialattachment(size(gen)[1], gen.numedges)



"""
    unipartite_preferentialattachment(S, L::IT; m::IT) where {IT <: Integer}

    Barabasi et al 


"""
function unipartite_preferentialattachment(S, L::IT) where {IT<:Integer}
    adjmat = zeros(Bool, S, S)

    edgesperround = Int32(floor(L / S))


    adjmat[1,1] = 1
    for s in 1:S
        degs = [sum(adjmat[:, i]) for i = 1:S]
        degdist = degs ./ sum(degs)
        for e = 1:edgesperround
            targ = rand(Categorical(degdist))
            adjmat[s, targ] = 1
            adjmat[targ, s] = 1
        end
    end
    return UnipartiteNetwork(adjmat)
end


"""
    bipartite_preferentialattachment(T, B, E::Int; m::Int)

    Filho and O'Neale 2019, based on the unipartite preferential attachment
    model from Barabasi 
    
    T -> num in set of nodes top set
    B -> number of nodes in bottom set
    E -> number of edges 
    m -> number of edges to add at each iteraction
"""
function bipartite_preferentialattachment(T::IT, B::IT, E::IT) where {IT<:Integer}
    adjacency_matrix = zeros(Bool, T, B)
    adjacency_matrix[1, 1] = 1

    numrounds = T + B
    newedgesperround::Int32 = floor(E / (T + B))
    t, b, roundct = 1, 1, 1
    while roundct < numrounds
        if t <= T
            b_degree = [sum(adjacency_matrix[:, b]) for b = 1:B]
            newedgelocationdist = b_degree ./ sum(b_degree)

            for e = 1:newedgesperround
                b_target = rand(Categorical(newedgelocationdist))
                adjacency_matrix[t, b_target] = 1
            end
            t += 1
        end

        if b <= B
            t_degree = [sum(adjacency_matrix[t, :]) for t = 1:T]
            newedgelocationdist = t_degree ./ sum(t_degree)

            for e = 1:newedgesperround
                t_target = rand(Categorical(newedgelocationdist))
                adjacency_matrix[t_target, b] = 1
            end
            b += 1
        end
        roundct = t + b
    end

    return BipartiteNetwork(adjacency_matrix)
end
