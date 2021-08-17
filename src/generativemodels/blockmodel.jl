
"""
    BlockModel{NT<:AbstractEcologicalNetwork,IT<:Integer,FT<:AbstractFloat} <: NetworkGenerator

    A `NetworkGenerator` for stochastic block models.

    https://en.wikipedia.org/wiki/Stochastic_block_model

    Takes a set group labels for each node (`nodelabels`) where the probability 
    of a link between node `i` (in group `G_i`) and node `j` (in group `G_j`)
    is given by a matrix `blocks`, where the `blocks[x,y]` is the probability of
    edges between group `x` and group `y`.

    ## Citation

    Stochastic blockmodels and community structure in networks
    Karrer & Newman, 2011
    DOI: 10.1103/PhysRevE.83.016107
"""
mutable struct BlockModel{NT<:AbstractEcologicalNetwork,IT<:Integer,FT<:AbstractFloat} <:
               NetworkGenerator
    networktype::Type{NT}
    size::Tuple{IT,IT}
    nodelabels::Tuple{Vector{IT},Vector{IT}}   # a vector of length 1 for unipartite, vec of length 2 for bipartite
    numblocks::Tuple{IT,IT}    # same if unipartite, diff if not 
    blocks::Matrix{FT}
end

"""
    _generate!(gen::BlockModel, ::Type{T}) where {T<:UnipartiteNetwork}
    
    Primary dispatch for generating unipartite networks using `BlockModel`. 
"""
_generate!(gen::BlockModel, ::Type{T}) where {T<:UnipartiteNetwork} =
    _unipartite_blockmodel(gen)


"""
_generate!(gen::BlockModel, ::Type{T}) where {T<:BipartiteNetwork}

Primary dispatch for generating bipartite networks using `BlockModel`. 
"""
_generate!(gen::BlockModel, ::Type{T}) where {T<:BipartiteNetwork} =
    _bipartite_blockmodel(gen)


"""
    BlockModel(labels::Vector{T}, blocks::Matrix{FT}) where {T<:Integer,FT<:AbstractFloat}

    Constructor for unipartite `BlockModel` for a set of `labels` and a matrix of block probabilities `blocks`.
"""
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

"""
    BlockModel(labels::Tuple{Vector{T},Vector{T}}, blocks::Matrix{FT}) where {T<:Integer,FT<:AbstractFloat}
    
    Constructor for bipartite `BlockModel` from a tuple `labels` of two sets of labels and a matrix of block probabilities `blocks`.
"""
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

"""
    _isunipartitegenerator(gen) 

    Used to check if generator `gen` passed to `rand(gen, UnipartiteNetwork)` 
    is a unipartite generator.
"""
_isunipartitegenerator(gen) =
    size(gen.nodelabels[1]) == size(gen.nodelabels[2]) &&
    length(unique(gen.nodelabels[1])) == length(unique(gen.nodelabels[2]))



"""
    _isbipartitegenerator(gen) 

    Used to check if generator `gen` passed to `rand(gen, BipartiteNetwork)` 
    is a bipartite generator.
"""
_isbipartitegenerator(gen) =
    size(gen.blocks)[1] == length(unique(gen.nodelabels[1])) &&
    size(gen.blocks)[2] == length(unique(gen.nodelabels[2]))



"""
    _unipartite_blockmodel(gen)

    Implmentation of generating networks from the `BlockModel` for unipartite networks.
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
    _bipartite_blockmodel(gen)

    Implmentation of generating networks from the `BlockModel` for bipartite networks.
"""
function _bipartite_blockmodel(gen)

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
