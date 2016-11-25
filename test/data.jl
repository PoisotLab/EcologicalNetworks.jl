module TestData
    using Base.Test
    using EcologicalNetwork

    # Stony
    @test typeof(stony()) <: Unipartite
    @test richness(stony()) == 113

    # McMullen
    @test typeof(mcmullen()) <: Bipartite
    @test size(mcmullen()) == (54, 105)

    # Ollerton
    @test typeof(ollerton()) <: Bipartite
    @test typeof(ollerton()) <: DeterministicNetwork
    @test size(ollerton()) == (26, 10)

end
