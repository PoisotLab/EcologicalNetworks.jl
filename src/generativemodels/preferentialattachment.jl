"""
    PreferentialAttachment
"""
mutable struct PreferentialAttachment{T<:Integer} <: NetworkGenerator 
    size::Tuple{T,T}
    numedges::Integer
end 
PreferentialAttachment(; size::T=30, connectance::FT=0.3) where {T <: Union{Tuple{Integer}, Integer}, FT <: AbstractFloat} = PreferentialAttachment(size, connectance)
PreferentialAttachment(sz::T, X::NT) where {T <: Integer, NT<:Number} = PreferentialAttachment((sz,sz), X)
PreferentialAttachment(sz::T, E::ET) where {T <: Tuple{Integer,Integer}, ET<:Integer} = PreferentialAttachment(sz, E)
PreferentialAttachment(sz::T, C::CT) where {T <: Tuple{Integer,Integer}, CT<:AbstractFloat} = PreferentialAttachment(sz, Int(floor(C*sz[1]*sz[2])))

_generate!(gen::PreferentialAttachment, ::Type{T}) where {T <: BipartiteNetwork} =  bipartite_preferentialattachment(size(gen)..., gen.numedges)




"""
    bipartite_preferentialattachment(T, B, E::Int; m::Int)

    Filho and O'Neale 2019, based on the unipartite preferential attachment
    model from Barabasi 
    
    T -> num in set of nodes top set
    B -> number of nodes in bottom set
    E -> number of edges 
    m -> number of edges to add at each iteraction
"""
function bipartite_preferentialattachment(T::IT, B::IT, E::IT) where {IT <: Integer}
    adjacency_matrix = zeros(Bool, T, B);
    adjacency_matrix[1,1] = 1

    numrounds = T+B;
    newedgesperround::Int32 = floor(E / (T+B));
    t,b, roundct = 1, 1, 1
    while roundct < numrounds
        if t <= T 
            b_degree = [sum(adjacency_matrix[:,b]) for b in 1:B] 
            newedgelocationdist = b_degree ./ sum(b_degree)

            for e in 1:newedgesperround
                b_target = rand(Categorical(newedgelocationdist))
                adjacency_matrix[t, b_target] = 1
            end
            t += 1
        end

        if b <= B  
            t_degree = [sum(adjacency_matrix[t,:]) for t in 1:T] 
            newedgelocationdist = t_degree ./ sum(t_degree)

            for e in 1:newedgesperround
                t_target = rand(Categorical(newedgelocationdist))
                adjacency_matrix[t_target, b] = 1
            end
            b += 1
        end
        roundct = t + b
    end

    return target(adjacency_matrix)
end


