"""
    ConfigurationModel{IT<:Integer} <: NetworkGenerator

    A `NetworkGenerator` for the configuration model. 

    The configuration model takes a fixed degree sequence `degreesequence`,
    which is the number of links `degreesequence[i]` for each node i.
    
    For unipartite networks, these edges are then distribution uniformly
    across other nodes, and for bipartite networks, they are drawn according
    to the degree sequence of the bottom node set.
"""
mutable struct ConfigurationModel{IT<:Integer} <: NetworkGenerator
    size::Tuple{IT,IT}
    degreesequence::Tuple{Vector{IT},Vector{IT}}
end

"""
    _generate!(gen::ConfigurationModel, ::Type{T}) where {T<:UnipartiteNetwork} 

    Primary dispatch for generating a unipartite network using the `ConfigurationModel`.

"""
_generate!(gen::ConfigurationModel, ::Type{T}) where {T<:UnipartiteNetwork} =
    _unipartite_configuration(gen)

"""
    _generate!(gen::ConfigurationModel, ::Type{T}) where {T<:BipartiteNetwork} 

    Primary dispatch for generating a bipartite network using the `ConfigurationModel`.

"""
_generate!(gen::ConfigurationModel, ::Type{T}) where {T<:BipartiteNetwork} =
    _bipartite_configuration(gen)

"""
    ConfigurationModel(S::IT, degreesequence::Vector{IT}) where {IT<:Integer} 

    Constructor for the `ConfigurationModel` for a `UnipartiteNetwork` with 
    `S` species and a degree list `degreesequence`
"""
ConfigurationModel(S::IT, degreesequence::Vector{IT}) where {IT<:Integer} =
    ConfigurationModel((S, S), (degreesequence, degreesequence))

"""
    ConfigurationModel(S::IT, degreesequence::Vector{IT}) where {IT<:Integer} 

    Constructor for the `ConfigurationModel` for a `BipartiteNetwork` with 
    T,B = `szs` species in the top and bottom sets, and a tuple of 
    degree lists `degreesequence` for each set.
"""
ConfigurationModel(
    szs::Tuple{IT,IT},
    degreesequences::Tuple{Vector{IT},Vector{IT}},
) where {IT<:Integer} = ConfigurationModel{IT}(szs, degreesequences)

"""
    _unipartite_configuration(gen)

    Implemnts the unipartite configuration model for a generator `gen::ConfigurationModel`
"""
function _unipartite_configuration(gen)
    S = gen.size[1]

    degsequence = gen.degreesequence[1]
    @assert max(degsequence...) < (S - 1) && S == length(degsequence)

    adjmat = zeros(Bool, S, S)

    for i = 1:S
        deg_i = degsequence[i]
        targs = filter!(x -> x != i, collect(1:S))
        j = sample(targs, deg_i, replace = false)
        adjmat[i, j] .= 1
    end
    return UnipartiteNetwork(adjmat)
end


"""
    _bipartite_configuration(gen)

    Implemnts the bipartite configuration model for a generator `gen::ConfigurationModel`
"""
function _bipartite_configuration(gen)
    T, B = size(gen)
    adjmat = zeros(Bool, T, B)

    t_sequence = gen.degreesequence[1]
    b_sequence = gen.degreesequence[2]

    b_degdist = b_sequence ./ sum(b_sequence)

    for t = 1:T
        deg_t = t_sequence[t]
        j = rand(Categorical(b_degdist), deg_t)
        adjmat[t, j] .= 1
    end
    return BipartiteNetwork(adjmat)
end
