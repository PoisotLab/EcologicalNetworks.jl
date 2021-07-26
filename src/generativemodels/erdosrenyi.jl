



"""
    ErdosRenyi
"""
mutable struct ErdosRenyi{T<:Integer, PT<:AbstractFloat} <: NetworkGenerator  
    size::Tuple{T,T}
    probability::PT
end 
ErdosRenyi(; size::T=30, connectance::FT=0.3) where {T <: Union{Tuple{Integer}, Integer}, FT <: AbstractFloat} = ErdosRenyi(size, connectance)
ErdosRenyi(sz::T, X::NT) where {T <: Integer, NT<:Number} = ErdosRenyi((sz,sz), X)
ErdosRenyi(sz::T, E::ET) where {T <: Tuple{Integer,Integer}, ET<:Integer} = ErdosRenyi(sz, E/(sz[1]*sz[2]))
ErdosRenyi(sz::T, C::CT) where {T <: Tuple{Integer,Integer}, CT<:AbstractFloat} = ErdosRenyi(sz, C)


_generate!(gen::ErdosRenyi, ::Type{T}) where {T <: UnipartiteNetwork} = unipartite_erdosrenyi(size(gen)[1], gen.probability)
_generate!(gen::ErdosRenyi, ::Type{T}) where {T <: BipartiteNetwork} = bipartite_erdosrenyi(size(gen)..., gen.probability)



"""
    unipartite_erdosrenyi(S, p; iterations = 10000)

    S -> number of nodes 
    p -> probability of any edge occuring
"""

function unipartite_erdosrenyi(S,p)
    adjacency_matrix = zeros(Bool,S,S);
    return UnipartiteNetwork(map(x -> rand() < p, adjacency_matrix))
end


"""
    bipartite_erdosrenyi(U, V, p; iterations = 10000)
    
    U -> number of nodes in bottom set
    V -> number of nodes in top set
    p -> probability of any edge occuring
"""

function bipartite_erdosrenyi(U,V,p)
    adjacency_matrix = zeros(Bool,U,V);

    for u in 1:U, v in 1:V
        adjacency_matrix[u,v] = rand() < p
    end
    return BipartiteNetwork(adjacency_matrix)
end


