module TestErdosRenyiModel
  using Test
  using EcologicalNetworks
  using Distributions: Categorical

  @test typeof(rand(ErdosRenyi(30, 0.1))) <: UnipartiteNetwork
  @test richness(rand(ErdosRenyi(50, 0.3))) == 50

end

