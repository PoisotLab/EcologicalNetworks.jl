
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
    blocks::Matrix{FT}
end

_toplabels(gen) = gen.nodelabels[1]
_bottomlabels(gen) = gen.nodelabels[2]
_numtopblocks(gen) = size(gen.blocks)[1]
_numbottomblocks(gen) = size(gen.blocks)[2]


"""
    _generate(gen::BlockModel, ::Type{T}) where {T<:UnipartiteNetwork}

    Primary dispatch for generating unipartite networks using `BlockModel`. 
"""
function _generate(gen::BlockModel, ::Type{T}) where {T<:UnipartiteNetwork}
    _isunipartitegenerator(gen) || throw(ArgumentError("Not a valid unipartite generator"))
    return _unipartite_blockmodel(gen)
end


"""
    _generate(gen::BlockModel, ::Type{T}) where {T<:BipartiteNetwork}

    Primary dispatch for generating bipartite networks using `BlockModel`. 
"""
function _generate(gen::BlockModel, ::Type{T}) where {T<:BipartiteNetwork}
    _isbipartitegenerator(gen) ||
        throw(ArgumentError("Block matrix is not the same size as labels"))
    return _bipartite_blockmodel(gen)
end

"""
    BlockModel(labels::Vector{T}, blocks::Matrix{FT}) where {T<:Integer,FT<:AbstractFloat}

    Constructor for unipartite `BlockModel` for a set of `labels` and a matrix of block probabilities `blocks`.
"""
BlockModel(labels::Vector{T}, blocks::Matrix{FT}) where {T<:Integer,FT<:AbstractFloat} =
    begin
        nlabs = length(labels)
        BlockModel(UnipartiteNetwork, (nlabs, nlabs), (labels, labels), blocks)
    end

"""
    BlockModel(labels::Tuple{Vector{T},Vector{T}}, blocks::Matrix{FT}) where {T<:Integer,FT<:AbstractFloat}
    
    Constructor for bipartite `BlockModel` from a tuple `labels` of two sets of labels and a matrix of block probabilities `blocks`.
"""
BlockModel(
    labels::Tuple{Vector{T},Vector{T}},
    blocks::Matrix{FT},
) where {T<:Integer,FT<:AbstractFloat} = begin
    BlockModel(
        BipartiteNetwork,
        (length(labels[1]), length(labels[2])),
        (labels[1], labels[2]),
        blocks,
    )
end

"""
    _isunipartitegenerator(gen) 

    Used to check if generator `gen` passed to `rand(gen, UnipartiteNetwork)` 
    is a unipartite generator.
"""
_isunipartitegenerator(gen) =
    size(gen)[1] == size(gen)[2] &&
    length(_toplabels(gen)) == size(gen)[1] &&
    length(_bottomlabels(gen)) == size(gen)[2] &&
    length(unique(_toplabels(gen))) == size(gen.blocks)[1]



"""
    _isbipartitegenerator(gen) 

    Used to check if generator `gen` passed to `rand(gen, BipartiteNetwork)` 
    is a bipartite generator.
"""
_isbipartitegenerator(gen) =
    length(_toplabels(gen)) == size(gen)[1] &&
    length(_bottomlabels(gen)) == size(gen)[2] &&
    length(unique(_toplabels(gen))) == size(gen.blocks)[1] &&
    length(unique(_bottomlabels(gen))) == size(gen.blocks)[2]






"""
    _unipartite_blockmodel(gen)

    Implmentation of generating networks from the `BlockModel` for unipartite networks.
"""
function _unipartite_blockmodel(gen)

    nodelabels = gen.nodelabels[1]
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

    toplabels = gen.nodelabels[1]
    bottomlabels = gen.nodelabels[2]
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
