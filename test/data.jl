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

    # Bluthgen
    @test typeof(bluthgen()) <: Bipartite
    @test typeof(bluthgen()) <: QuantitativeNetwork
    @test size(bluthgen()) == (41, 51)

    # Lake of the Woods
    @test typeof(woods()) <: Bipartite
    @test typeof(woods()) <: QuantitativeNetwork
    @test size(woods()) == (144, 31)

    # Robertson
    @test typeof(robertson()) <: Bipartite
    @test typeof(robertson()) <: DeterministicNetwork
    @test size(robertson()) == (1428, 456)

end
