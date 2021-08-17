
"""
    BlockModel

    

"""
mutable struct BlockModel{NT<:AbstractEcologicalNetwork,IT<:Integer,FT<:AbstractFloat} <:
               NetworkGenerator
    networktype::Type{NT}
    size::Tuple{IT,IT}
    nodelabels::Tuple{Vector{IT},Vector{IT}}   # a vector of length 1 for unipartite, vec of length 2 for bipartite
    numblocks::Tuple{IT,IT}    # same if unipartite, diff if not 
    blocks::Matrix{FT}
end

_generate!(gen::BlockModel, ::Type{T}) where {T<:UnipartiteNetwork} =
    _unipartite_blockmodel(gen)
_generate!(gen::BlockModel, ::Type{T}) where {T<:BipartiteNetwork} =
    _bipartite_blockmodel(gen)


# unipartite constructor from block matrix
BlockModel(labels::Vector{T}, blocks::Matrix{FT}) where {T<:Integer,FT<:AbstractFloat} =
    begin
        nlabs = length(unique(labels))

        # check params
        if size(labels[1]) != size(labels[2]) ||
           length(unique(labels[1])) != length(unique(labels[2]))
            @error "not a unipartite set of labels"
        end
        BlockModel(
            UnipartiteNetwork,
            (nlabs, nlabs),
            (labels, labels),
            (nlabs, nlabs),
            blocks,
        )
    end


# biipartite constructor from a tuple of labels and a block matrix
BlockModel(
    labels::Tuple{Vector{T},Vector{T}},
    blocks::Matrix{FT},
) where {T<:Integer,FT<:AbstractFloat} = begin
    tlabs = length(unique(labels[1]))
    blabs = length(unique(labels[2]))

    BlockModel(
        BipartiteNetwork,
        (length(tlabs), length(blabs)),
        (labels[1], labels[2]),
        (tlabs, blabs),
        blocks,
    )
end


_isunipartitegenerator(gen) =
    size(gen.nodelabels[1]) == size(gen.nodelabels[2]) &&
    length(unique(gen.nodelabels[1])) == length(unique(gen.nodelabels[2]))



_isbipartitegenerator(gen) =
    size(gen.blocks)[1] == length(unique(gen.nodelabels[1])) &&
    size(gen.blocks)[2] == length(unique(gen.nodelabels[2]))



"""
    _unipartite_blockmodel(M)
"""
function _unipartite_blockmodel(gen)
    _isunipartitegenerator(gen) || return @error "not a valid unipartite generator"

    nodelabels = gen.nodelabels[1]
    numblocks = gen.numblocks[1]
    blockmatrix = gen.blocks

    S = length(nodelabels)

    adjacency_matrix = zeros(Bool, S, S)

    for i = 1:S, j = 1:S
        iblock = nodelabels[i]
        jblock = nodelabels[j]
        adjacency_matrix[i, j] = rand() < blockmatrix[iblock, jblock]
    end
    return UnipartiteNetwork(adjacency_matrix)
end



"""
    _bipartite_blockmodel(M)

    Generates a bipartite network from a matrix `M` which gives the 
    probability M_ij that an edge exists between node `i` and `j`, where
    `i` and `j` are in different partitions.  
"""
function _bipartite_blockmodel(gen) where {FT<:AbstractFloat}

    _isbipartitegenerator(gen) || return @error "not a valid bipartite generator"

    toplabels = gen.nodelabels[1]
    bottomlabels = gen.nodelabels[2]
    topblocks = gen.numblocks[1]
    bottomblocks = gen.numblocks[2]
    blockmatrix = gen.blocks   # a topblocks x bottomblocks matrix

    T = length(toplabels)
    B = length(bottomlabels)
    adjacency_matrix = zeros(Bool, T, B)

    for i = 1:T, j = 1:B
        iblock = toplabels[i]
        jblock = bottomlabels[j]
        adjacency_matrix[i, j] = rand() < blockmatrix[iblock, jblock]
    end
    return BipartiteNetwork(adjacency_matrix)
end
