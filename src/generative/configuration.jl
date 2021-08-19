"""
    Configuration{IT<:Integer} <: NetworkGenerator

    A `NetworkGenerator` for the configuration model. 

    The configuration model takes a fixed degree sequence `degreesequence`,
    which is the number of links `degreesequence[i]` for each node i.
    
    For unipartite networks, these edges are then distribution uniformly
    across other nodes, and for bipartite networks, they are drawn according
    to the degree sequence of the bottom node set.
"""
mutable struct Configuration{IT<:Integer} <: NetworkGenerator
    size::Tuple{IT,IT}
    degreesequence::Tuple{Vector{IT},Vector{IT}}
end

"""
    _generate(gen::Configuration, ::Type{T}) where {T<:UnipartiteNetwork} 

    Primary dispatch for generating a unipartite network using the `Configuration`.

"""
_generate(gen::Configuration, ::Type{T}) where {T<:UnipartiteNetwork} =
    _unipartite_configuration(gen)

"""
    _generate(gen::Configuration, ::Type{T}) where {T<:BipartiteNetwork} 

    Primary dispatch for generating a bipartite network using the `Configuration`.

"""
_generate(gen::Configuration, ::Type{T}) where {T<:BipartiteNetwork} =
    _bipartite_configuration(gen)

"""
    Configuration(S::IT, degreesequence::Vector{IT}) where {IT<:Integer} 

    Constructor for the `Configuration` for a `UnipartiteNetwork` with 
    `S` species and a degree list `degreesequence`
"""
Configuration(S::IT, degreesequence::Vector{IT}) where {IT<:Integer} =
    Configuration((S, S), (degreesequence, degreesequence))

"""
    _unipartite_configuration(gen)

    Implemnts the unipartite configuration model for a generator `gen::Configuration`
"""
function _unipartite_configuration(gen)
    S = gen.size[1]

    degsequence = gen.degreesequence[1]
    max(degsequence...) < (S - 1) && S == length(degsequence) || throw(
        ArgumentError(
            "the length of the degree sequence is not the same as number of species ",
        ),
    )

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

    Implemnts the bipartite configuration model for a generator `gen::Configuration`
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
