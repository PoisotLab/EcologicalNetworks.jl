module TestData
    using Base.Test
    using EcologicalNetwork

    # Stony
    @test typeof(stony()) <: Unipartite
    @test richness(stony()) == 113

    # McMullen
    @test typeof(mcmullen()) <: Bipartite
    @test size(mcmullen()) == (54, 105)
end
