import Base.convert

"""
    convert{IT}(::Type{UnipartiteNetwork}, N::BipartiteNetwork{IT})

Projects a bipartite network in its unipartite representation.
"""
function convert(::Type{UnipartiteNetwork}, N::T) where {T <: BipartiteNetwork}
    itype = eltype(N.A)
    S = copy(species(N))
    B = zeros(itype, (richness(N), richness(N)))
    B[1:size(N)[1],size(N)[1]+1:richness(N)] = N.A
    return UnipartiteNetwork(B, S)
end

"""
    convert{NT,IT}(::Type{UnipartiteProbabilisticNetwork}, N::BipartiteProbabilisticNetwork{NT,IT})

TODO
"""
function convert(::Type{UnipartiteProbabilisticNetwork}, N::T) where {T <: BipartiteProbabilisticNetwork}
    itype = eltype(N.A)
    S = copy(species(N))
    B = zeros(itype, (richness(N), richness(N)))
    B[1:size(N)[1],size(N)[1]+1:richness(N)] = N.A
    return UnipartiteProbabilisticNetwork(B, S)
end

"""
    convert{NT,IT}(::Type{UnipartiteQuantitativeNetwork}, N::BipartiteQuantitativeNetwork{NT,IT})

TODO
"""
function convert(::Type{UnipartiteQuantitativeNetwork}, N::T) where {T <: BipartiteQuantitativeNetwork}
    itype = eltype(N.A)
    S = copy(species(N))
    B = zeros(itype, (richness(N), richness(N)))
    B[1:size(N)[1],size(N)[1]+1:richness(N)] = N.A
    return UnipartiteQuantitativeNetwork(B, S)
end

"""
    convert{NT,IT}(::Type{UnipartiteNetwork}, N::UnipartiteQuantitativeNetwork{NT,IT})

TODO
"""
function convert(::Type{UnipartiteNetwork}, N::T) where {T <: UnipartiteQuantitativeNetwork}
    S = copy(species(N))
    B = N.A.>zero(eltype(N.A))
    return UnipartiteNetwork(convert(Array{Bool,2}, B), S)
end

"""
    convert{NT,IT}(::Type{BipartiteNetwork}, N::BipartiteQuantitativeNetwork{NT,IT})

TODO
"""
function convert(::Type{BipartiteNetwork}, N::T) where {T <: BipartiteQuantitativeNetwork}
    R = copy(species(N, 1))
    B = copy(species(N, 2))
    C = N.A.>zero(eltype(N.A))
    return BipartiteNetwork(convert(Array{Bool,2}, C), R, B)
end

"""
    convert(::Type{AbstractUnipartiteNetwork}, N::AbstractBipartiteNetwork)

Projects any bipartite network in its unipartite representation. This function
will call the correct type-to-type `convert` function depending on the type of
the input network.

The type to be converted to *must* be `AbstractUnipartiteNetwork` -- for
example, converting a bipartite probabilistic network to a probabilistic
unipartite network is not a meaningful operation.
"""
function convert(::Type{AbstractUnipartiteNetwork}, N::AbstractBipartiteNetwork)
    if typeof(N) <: QuantitativeNetwork
        return convert(UnipartiteQuantitativeNetwork, N)
    end
    if typeof(N) <: BinaryNetwork
        return convert(UnipartiteNetwork, N)
    end
    if typeof(N) <: ProbabilisticNetwork
        return convert(UnipartiteProbabilisticNetwork, N)
    end
end

"""
    convert(::Type{BinaryNetwork}, N::QuantitativeNetwork)

Projects any bipartite network in its unipartite representation. This function
will call the correct type-to-type `convert` function depending on the type of
the input network.

This function does *not* work for probabilistic networks. The operation of
generating a deterministic network from a probabilistic one is different from a
simple conversion: it can be done either through random draws, or by selecting
only interactions with a probability greater than 0.
"""
function convert(::Type{BinaryNetwork}, N::QuantitativeNetwork)
    if typeof(N) <: BipartiteQuantitativeNetwork
        return convert(BipartiteNetwork, N)
    end
    if typeof(N) <: UnipartiteQuantitativeNetwork
        return convert(UnipartiteNetwork, N)
    end
end
