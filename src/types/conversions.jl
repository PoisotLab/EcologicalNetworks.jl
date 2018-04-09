import Base.convert

function convert{IT}(::Type{UnipartiteNetwork}, N::BipartiteNetwork{IT})
    itype = eltype(N.A)
    S = copy(species(N))
    B = zeros(itype, (richness(N), richness(N)))
    B[1:size(N)[1],size(N)[1]+1:richness(N)] = N.A
    return UnipartiteNetwork(B, S)
end

function convert{NT,IT}(::Type{UnipartiteProbabilisticNetwork}, N::BipartiteProbabilisticNetwork{NT,IT})
    itype = eltype(N.A)
    S = copy(species(N))
    B = zeros(itype, (richness(N), richness(N)))
    B[1:size(N)[1],size(N)[1]+1:richness(N)] = N.A
    return UnipartiteProbabilisticNetwork(B, S)
end

function convert{NT,IT}(::Type{UnipartiteQuantitativeNetwork}, N::BipartiteQuantitativeNetwork{NT,IT})
    itype = eltype(N.A)
    S = copy(species(N))
    B = zeros(itype, (richness(N), richness(N)))
    B[1:size(N)[1],size(N)[1]+1:richness(N)] = N.A
    return UnipartiteQuantitativeNetwork(B, S)
end

function convert{NT,IT}(::Type{UnipartiteNetwork}, N::UnipartiteQuantitativeNetwork{NT,IT})
    S = copy(species(N))
    B = N.A.>zero(eltype(N.A))
    return UnipartiteNetwork(convert(Array{Bool,2}, B), S)
end

function convert{NT,IT}(::Type{BipartiteNetwork}, N::BipartiteQuantitativeNetwork{NT,IT})
    T = copy(species(N, 1))
    B = copy(species(N, 2))
    C = N.A.>zero(eltype(N.A))
    return BipartiteNetwork(convert(Array{Bool,2}, C), T, B)
end

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
