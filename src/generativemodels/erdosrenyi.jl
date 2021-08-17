"""
    ErdosRenyi{T<:Integer,PT<:AbstractFloat} <: NetworkGenerator

    A `NetworkGenerator` which generates both bipartite or unipartite
    networks where every possible edge exists with a fixed `probability`.
    
    ```
        rand(ErdosRenyi(50, 0.3))
        > 50x50 unipartite network

        rand(ErdosRenyi(50, 0.3), UnipartiteNetwork)
        > 50x50 unipartite network

        rand(ErdosRenyi((50,30), 0.3))
        > 50x30 bipartite network

        rand(ErdosRenyi((50,30), 0.3), BipartiteNetwork)
        > 50x30 bipartite network
    ```
"""
mutable struct ErdosRenyi{T<:Integer,PT<:AbstractFloat} <: NetworkGenerator
    size::Tuple{T,T}
    probability::PT
end

"""
    _generate!(gen::ErdosRenyi, ::Type{T}) where {T<:UnipartiteNetwork} 

    Primary dispatch for generating networks using `ErdosRenyi` for `UnipartiteNetwork`
"""
function _generate!(gen::ErdosRenyi, ::Type{T}) where {T<:UnipartiteNetwork} 
    return _unipartite_erdosrenyi(gen)
end 

"""
    _generate!(gen::ErdosRenyi, ::Type{T}) where {T<:BipartiteNetwork} 

    Primary dispatch for generating networks using `ErdosRenyi` for `BipartiteNetwork`s
"""
function _generate!(gen::ErdosRenyi, ::Type{T}) where {T<:BipartiteNetwork} 
    return _bipartite_erdosrenyi(gen)
end

"""
    ErdosRenyi(S::T, X::NT) where {T<:Integer,NT<:Number} 

    Constructor for `ErdosRenyi` generators for a UnipartiteNetwork with
    `S` species and either a connectance (as float) or number of links (as int).
"""
ErdosRenyi(S::T, X::NT) where {T<:Integer,NT<:Number} = ErdosRenyi((S,S), X)

"""
    ErdosRenyi(sz::T, E::ET) where {T<:Tuple{Integer,Integer},ET<:Integer} 

    Constructor for `ErdosRenyi` generators for a UnipartiteNetwork with
    `S` species and either a connectance (as float) or number of links (as int).
"""
ErdosRenyi(sz::T, E::ET) where {T<:Tuple{Integer,Integer},ET<:Integer} =
    ErdosRenyi(sz, E / (sz[1] * sz[2]))

"""
    ErdosRenyi(sz::T, C::CT) where {T<:Tuple{Integer,Integer},CT<:AbstractFloat}

    Constructor for `ErdosRenyi` generators for a UnipartiteNetwork with
    `S` species and either a connectance `C`.
"""
ErdosRenyi(sz::T, C::CT) where {T<:Tuple{Integer,Integer},CT<:AbstractFloat} =
    ErdosRenyi(sz, C)




"""
    _unipartite_erdosrenyi(gen)

    Implementation of generating `ErdosRenyi` unpartite networks
"""
function _unipartite_erdosrenyi(gen)
    S = size(gen)[1]
    p = gen.probability

    adjacency_matrix = zeros(Bool, S, S)
    return UnipartiteNetwork(map(x -> rand() < p, adjacency_matrix))
end


"""
    _bipartite_erdosrenyi(gen)

    Implementation of generating `ErdosRenyi` bipartite networks
"""
function _bipartite_erdosrenyi(gen)
    U,V = size(gen)
    p = gen.probability

    adjacency_matrix = zeros(Bool, U, V)

    for u = 1:U, v = 1:V
        adjacency_matrix[u, v] = rand() < p
    end
    return BipartiteNetwork(adjacency_matrix)
end
