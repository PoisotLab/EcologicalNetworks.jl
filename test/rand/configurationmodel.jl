module TestConfigurationModel
  using Test
  using EcologicalNetworks
  using Distributions: Poisson

  @test typeof(rand(ConfigurationModel(50, [rand(Poisson(5)) for i in 1:50]))) <: UnipartiteNetwork
  @test richness(rand(ConfigurationModel(50, [rand(Poisson(5)) for i in 1:50]))) == 50

end


