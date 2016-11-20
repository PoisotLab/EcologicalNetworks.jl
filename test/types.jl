module TestTypes
    using Base.Test
    using EcologicalNetwork

    @test typeof(BipartiteProbaNetwork(rand(3, 3))) == BipartiteProbaNetwork
    @test typeof(BipartiteProbaNetwork(rand(3, 3))) <: Bipartite
    @test typeof(BipartiteProbaNetwork(rand(3, 3))) <: ProbabilisticNetwork

end
