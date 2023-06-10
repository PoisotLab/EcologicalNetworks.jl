Base.eltype(::Bipartite{T}) where {T} = T
Base.eltype(::Unipartite{T}) where {T} = T
Base.eltype(::Binary) = Bool
Base.eltype(::Quantitative{T}) where {T} = T
Base.eltype(::Probabilistic{T}) where {T} = T

@testitem "We can detect the type of a partiteness struct" begin
    part = Bipartite([:A, :B, :C], [:a, :b, :c])
    @test eltype(part) == Symbol

    part = Unipartite(["A", "B", "C"])
    @test eltype(part) == String
end

species(N::Bipartite) = vcat(N.top, N.bottom)
species(N::Unipartite) = N.margin
species(N::SpeciesInteractionNetwork) = species(N.nodes)

species(N::Bipartite, dims::Integer) = dims==1 ? N.top : N.bottom
species(N::Unipartite, ::Integer) = N.margin
species(N::SpeciesInteractionNetwork, dims::Integer) = species(N.nodes, dims)

@testitem "We can access the species on all sides of the network" begin
    t = [:A, :B, :C]
    b = [:a, :b]

    B = Bipartite(t, b)
    @test species(B, 1) == t
    @test species(B, 2) == b
    @test species(B) == vcat(t,b)
    
    U = Unipartite(t)
    @test species(U, 1) == species(U, 2)
    @test species(U) == species(U, 1)
end

richness(N::Partiteness) = length(species(N))
richness(N::Partiteness, dims::Integer) = length(species(N, dims))
richness(N::SpeciesInteractionNetwork) = length(species(N.nodes))
richness(N::SpeciesInteractionNetwork, dims::Integer) = length(species(N.nodes, dims))