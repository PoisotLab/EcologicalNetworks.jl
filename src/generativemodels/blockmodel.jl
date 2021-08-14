
"""
    BlockModel

    What this really should do is take a vector V where each element 
    V_i is the module that node i belongs to. Then build a ProbabilisticNetwork
    based on a set of within-group / between-group probabilities   
"""
mutable struct BlockModel{LT, IT <: Integer, FT <: AbstractFloat} <: NetworkGenerator
    size::Tuple{IT,IT}
    nodelabels::Array{LT,1}
    numblocks::IT
    blocks::Matrix{FT}
end


BlockModel(labels::Vector{T}) where {T <: Integer} = begin
    nlabs = length(unique(labels))
    BlockModel((nlabs,nlabs), labels, nlabs, rand(nlabs,nlabs) ) ;
end 

_generate!(gen::BlockModel, ::Type{T}) where {T <: UnipartiteNetwork} = _unipartite_blockmodel(gen)
_generate!(gen::BlockModel, ::Type{T}) where {T <: BipartiteNetwork} = _bipartite_blockmodel(gen)



"""
    unipartite_blockmodel(M)
"""
function _unipartite_blockmodel(gen)
    
    nodelabels = gen.nodelabels
    numblocks = gen.nodelabels
    blockmatrix = gen.blocks
    
    S = length(nodelabels)

    adjacency_matrix = zeros(Bool,S,S)

    for i in 1:S, j in 1:S
        iblock = nodelabels[i]
        jblock = nodelabels[j]
        adjacency_matrix[i,j] = rand() < blockmatrix[iblock,jblock]
    end
    return UnipartiteNetwork(adjacency_matrix)
end



"""
    bipartite_blockmodel(M)

    Generates a bipartite network from a matrix `M` which gives the 
    probability M_ij that an edge exists between node `i` and `j`, where
    `i` and `j` are in different partitions.  
"""
function _bipartite_blockmodel(gen) where {FT <: AbstractFloat}

end

