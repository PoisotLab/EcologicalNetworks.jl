import Base.convert

"""
    convert(::Type{UnipartiteNetwork}, N::T) where {T <: BipartiteNetwork}

Projects a deterministic bipartite network in its unipartite representation.
"""
function convert(::Type{UnipartiteNetwork}, N::T) where {T <: BipartiteNetwork}
    itype = first(eltype(N))
    S = copy(species(N))
    B = zeros(itype, (richness(N), richness(N)))
    B[1:size(N)[1],size(N)[1]+1:richness(N)] = N.edges
    return UnipartiteNetwork(sparse(B), S)
end

"""
    convert(::Type{UnipartiteProbabilisticNetwork}, N::T) where {T <: BipartiteProbabilisticNetwork}

Projects a probabilistic bipartite network in its unipartite representation.
"""
function convert(::Type{UnipartiteProbabilisticNetwork}, N::T) where {T <: BipartiteProbabilisticNetwork}
    itype = first(eltype(N))
    S = copy(species(N))
    B = zeros(itype, (richness(N), richness(N)))
    B[1:size(N)[1],size(N)[1]+1:richness(N)] = N.edges
    return UnipartiteProbabilisticNetwork(sparse(B), S)
end

"""
    convert(::Type{UnipartiteQuantitativeNetwork}, N::T) where {T <: BipartiteQuantitativeNetwork}

Projects a quantitative bipartite network in its unipartite representation.
"""
function convert(::Type{UnipartiteQuantitativeNetwork}, N::T) where {T <: BipartiteQuantitativeNetwork}
    itype = first(eltype(N))
    S = copy(species(N))
    B = zeros(itype, (richness(N), richness(N)))
    B[1:size(N)[1],size(N)[1]+1:richness(N)] = N.edges
    return UnipartiteQuantitativeNetwork(sparse(B), S)
end

"""
    convert(::Type{UnipartiteNetwork}, N::T) where {T <: UnipartiteQuantitativeNetwork}

Convert a unipartite quantitative network to a unipartite binary network. This
amounts to *removing* the quantitative information.
"""
function convert(::Type{UnipartiteNetwork}, N::T) where {T <: UnipartiteQuantitativeNetwork}
    S = copy(species(N))
    B = dropzeros(N.edges)
    return UnipartiteNetwork(B .!= zero(eltype(B)), S)
end

"""
    convert(::Type{BipartiteNetwork}, N::T) where {T <: BipartiteQuantitativeNetwork}

Convert a bipartite quantitative network to a bipartite binary network. This
amounts to *removing* the quantitative information.
"""
function convert(::Type{BipartiteNetwork}, N::NT) where {NT <: BipartiteQuantitativeNetwork}
    T = copy(species(N; dims=1))
    B = copy(species(N; dims=2))
    M = dropzeros(N.edges)
    return BipartiteNetwork(M .!= zero(eltype(M)), T, B)
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
only interactions with a probability greater than 0 (`N>0.0` will do this).
"""
function convert(::Type{BinaryNetwork}, N::QuantitativeNetwork)
    if typeof(N) <: BipartiteQuantitativeNetwork
        return convert(BipartiteNetwork, N)
    end
    if typeof(N) <: UnipartiteQuantitativeNetwork
        return convert(UnipartiteNetwork, N)
    end
end

# Conversion to bipartite

type_pairs = [
    (:BipartiteNetwork, :UnipartiteNetwork),
    (:BipartiteProbabilisticNetwork, :UnipartiteProbabilisticNetwork),
    (:BipartiteQuantitativeNetwork, :UnipartiteQuantitativeNetwork)
    ]

for comb in type_pairs
    t1, t2 = comb
    eval(
    quote
        """
            convert(::Type{$($t1)}, N::T) where {T <: $($t2)}

        Projects a unipartite network (specifically, a `$($t1)`) to its bipartite
        representation. The following checks are performed.

        First, the network *cannot* be degenerate, since species with no interactions
        cannot be assigned to a specific level. Second, the species cannot have both in
        and out degree. If these conditions are met, the bipartite network will be
        returned.
        """
        function convert(::Type{$t1}, N::T) where {T <: $t2}
            isdegenerate(N) && throw(ArgumentError("Impossible to convert a degenerate unipartite network into a bipartite one"))
            d1 = degree(N; dims=1)
            d2 = degree(N; dims=2)
            for s in species(N)
                (d1[s]*d2[s] == 0) || throw(ArgumentError("Species $s has both in and out degree"))
            end
            top_species = collect(keys(filter(p -> p.second == zero(eltype(N.edges)), d2)))
            bot_species = collect(keys(filter(p -> p.second == zero(eltype(N.edges)), d1)))
            A = zeros(eltype(N)[1], (length(top_species), length(bot_species)))
            B = $t1(sparse(A), top_species, bot_species)
            for s1 in species(B; dims=1), s2 in species(B; dims=2)
                B[s1,s2] = N[s1, s2]
            end
            return B
        end
    end
    )
end
