
"""
    BlockModel

    What this really should do is take a vector V where each element 
    V_i is the module that node i belongs to. Then build a ProbabilisticNetwork
    based on a set of within-group / between-group probabilities   
"""
mutable struct BlockModel{LT <: Integer, IT <: Integer, FT <: AbstractFloat} <: NetworkGenerator
    nodelabels::AbstractArray{LT,1}
    nummodules::IT
    ingroup::FT
    outgroup::FT
end


BlockModel(labels::Vector{T}) where {T <: Integer} = BlockModel(labels, length(unique(labels)));

_generate!(gen::BlockModel, ::T) where {T <: UnipartiteNetwork} = unipartiteblockmodel()
_generate!(gen::BlockModel, ::T) where {T <: BipartiteNetwork} = bipartiteblockmodel()



"""
    unipartite_blockmodel(M)
"""
function unipartite_blockmodel(T,B,M)
    adjacency_matrix = map(x ->rand() < x,  M)
    T,B = size(adjacency_matrix)
    return adjacency_matrix
end


"""
    bipartite_blockmodel(M)

    Generates a bipartite network from a matrix `M` which gives the 
    probability M_ij that an edge exists between node `i` and `j`, where
    `i` and `j` are in different partitions.  
"""
function bipartite_blockmodel(T,B,M) where {FT <: AbstractFloat}
    adjacency_matrix = map(x ->rand() < x,  M)
    T,B = size(adjacency_matrix)
    return adjacency_matrix
end

