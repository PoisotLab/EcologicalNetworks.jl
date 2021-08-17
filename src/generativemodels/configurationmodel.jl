"""
    ConfigurationModel

    cite here
"""
mutable struct ConfigurationModel{IT<:Integer} <: NetworkGenerator
    size::Tuple{IT,IT}
    degreesequence::Tuple{Vector{IT},Vector{IT}}
end

ConfigurationModel(S::IT, degreesequence::Vector{IT}) where {IT<:Integer} =
    ConfigurationModel((S, S), (degreesequence, degreesequence))


ConfigurationModel(
    szs::Tuple{IT,IT},
    degreesequences::Tuple{Vector{IT},Vector{IT}},
) where {IT<:Integer} = ConfigurationModel{IT}(szs, degreesequences)


_generate!(gen::ConfigurationModel, ::Type{T}) where {T<:UnipartiteNetwork} =
    _unipartite_configuration(gen)
_generate!(gen::ConfigurationModel, ::Type{T}) where {T<:BipartiteNetwork} =
    _bipartite_configuration(gen)

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
