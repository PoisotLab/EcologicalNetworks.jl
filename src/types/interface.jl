import Base: eltype

Base.eltype(::Bipartite{T}) where {T} = T
Base.eltype(::Unipartite{T}) where {T} = T
Base.eltype(::Binary) = Bool
Base.eltype(::Quantitative{T}) where {T} = T
Base.eltype(::Probabilistic{T}) where {T} = T
Base.eltype(S::SpeciesInteractionNetwork) = (Type{eltype(S.nodes)}, Type{eltype(S.nodes)}, eltype(S.edges))

@testitem "We can detect the type of a partiteness struct" begin
    part = Bipartite([:A, :B, :C], [:a, :b, :c])
    @test eltype(part) == Symbol

    part = Unipartite(["A", "B", "C"])
    @test eltype(part) == String
end

species(N::Bipartite) = vcat(N.top, N.bottom)
species(N::Unipartite) = N.margin
species(N::SpeciesInteractionNetwork) = species(N.nodes)

richness(N::Partiteness) = length(species(N))
richness(N::SpeciesInteractionNetwork) = length(species(N.nodes))