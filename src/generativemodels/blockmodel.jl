
"""
    BlockModel

    What this really should do is take a vector V where each element 
    V_i is the module that node i belongs to. Then build a ProbabilisticNetwork
    based on a set of within-group / between-group probabilities   
"""
mutable struct BlockModel{T<:AbstractFloat, IT <: Integer} <: NetworkGenerator
    nodelabels::AbstractArray{T,2}
    modules::IT
end


"""
    bipartite_blockmodel(M)

    Generates a bipartite network from a matrix `M` which gives the 
    probability M_ij that an edge exists between node `i` and `j`, where
    `i` and `j` are in different partitions.  
"""
function bipartite_blockmodel(M::AbstractArray{FT,2}) where {FT <: AbstractFloat}
    adjacency_matrix = map(x ->rand() < x,  M)
    T,B = size(adjacency_matrix)
    return adjacency_matrix
end

