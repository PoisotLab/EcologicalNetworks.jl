"""
    DegreeDistributionModel{IT<:Integer,DT<:Distribution} <: NetworkGenerator
    
    A `NetworkGenerator` for the degree-distribution model, where the distribution
    of the number of links for node is given by `dist`.
"""
mutable struct DegreeDistributionModel{IT<:Integer,DT<:Distribution} <: NetworkGenerator
    size::Tuple{IT,IT}
    dist::DT
end


"""
    _generate!(gen::DegreeDistributionModel, ::Type{T}) where {T<:BipartiteNetwork} 

    Primary dispatch for generating bipartite networks using `DegreeDistributionModel`
"""
_generate!(gen::DegreeDistributionModel, ::Type{T}) where {T<:BipartiteNetwork} =
    _bipartite_degreedist(gen)

"""
    _generate!(gen::DegreeDistributionModel, ::Type{T}) where {T<:UnipartiteNetwork} 

    Primary dispatch for generating unipartite networks using `DegreeDistributionModel`
"""
_generate!(gen::DegreeDistributionModel, ::Type{T}) where {T<:UnipartiteNetwork} =
    _unipartite_degreedist(gen)

"""
    DegreeDistributionModel(S::IT, dist::DT) where {IT<:Integer,DT<:Distribution}    
   
    Constructor for the `DegreeDistributionModel` for a unipartite network with `S`
    species and distribution `dist`.
"""
function DegreeDistributionModel(S::IT, dist::DT) where {IT<:Integer,DT<:Distribution}
    return DegreeDistributionModel{IT,DT}((S, S), dist)
end


"""
    DegreeDistributionModel(S::IT, dist::DT) where {IT<:Integer,DT<:Distribution}    
   
    Constructor for the `DegreeDistributionModel` for a bipartite network with `T,U=sz`
    species and distribution `dist`.
"""
function DegreeDistributionModel(
    sz::Tuple{IT,IT},
    dist::DT,
) where {IT<:Integer,DT<:Distribution}
    return DegreeDistributionModel{IT,DT}(sz, dist)
end


"""
    _unipartite_degreedist(gen)

    Implments generation of unipartite networks using `DegreeDistributionModel`.
"""
function _unipartite_degreedist(gen)
    S = size(gen)[1]

    adjacency_matrix = zeros(Bool, S, S)

    for i = 1:S, j = 1:S
        k_i = min(rand(gen.dist), S)
        attach = sample([i for i = 1:S], k_i, replace = false)
        adjacency_matrix[i, attach] .= 1
    end
    return UnipartiteNetwork(adjacency_matrix)
end

"""
    _bipartite_degreedist(gen)

    Implments generation of bipartite networks using `DegreeDistributionModel`.
"""
function _bipartite_degreedist(gen)
    T, B = size(gen)

    adjacency_matrix = zeros(Bool, T, B)

    for t = 1:T
        k_t = min(rand(gen.dist), T)
        attach = sample([i for i = 1:B], k_t, replace = false)
        adjacency_matrix[t, attach] .= 1
    end
    return BipartiteNetwork(adjacency_matrix)
end
