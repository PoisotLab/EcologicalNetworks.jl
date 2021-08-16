"""
    DegreeDistributionModel
"""
mutable struct DegreeDistributionModel{IT<:Integer,DT<:Distribution} <: NetworkGenerator
    size::Tuple{IT,IT}
    dist::DT
end


function DegreeDistributionModel(S::IT, dist::DT) where {IT<:Integer,DT<:Distribution}
    return DegreeDistributionModel{IT,DT}((S,S), dist)
end

function DegreeDistributionModel(sz::Tuple{IT,IT}, dist::DT) where {IT<:Integer,DT<:Distribution}
    return DegreeDistributionModel{IT,DT}(sz, dist)
end


_generate!(gen::DegreeDistributionModel, ::Type{T}) where {T<:BipartiteNetwork} =
    _bipartite_degreedist(gen)

_generate!(gen::DegreeDistributionModel, ::Type{T}) where {T<:UnipartiteNetwork} =
    _unipartite_degreedist(gen)


function _unipartite_degreedist(gen)
    S = size(gen)[1]

    adjacency_matrix = zeros(Bool, S,S)

    for i = 1:S, j = 1:S
        k_i = min(rand(gen.dist), S)
        attach = sample([i for i in 1:S], k_i, replace = false)
        adjacency_matrix[i, attach] .= 1
    end
    return UnipartiteNetwork(adjacency_matrix)
end


function _bipartite_degreedist(gen)
    T,B = size(gen)

    adjacency_matrix = zeros(Bool, T, B)

    for t = 1:T
        k_t = min(rand(gen.dist), T)
        attach = sample([i for i in 1:B], k_t, replace = false)
        adjacency_matrix[t, attach] .= 1
    end
    return BipartiteNetwork(adjacency_matrix)
end

