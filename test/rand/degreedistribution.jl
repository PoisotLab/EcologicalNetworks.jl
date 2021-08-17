module TestDegreeDistributionModel
  using Test
  using EcologicalNetworks
  using Distributions: Poisson

  @test typeof(rand(DegreeDistributionModel(50, Poisson(5)))) <: UnipartiteNetwork
  @test richness(rand(DegreeDistributionModel(50, Poisson(5)))) == 50

end

