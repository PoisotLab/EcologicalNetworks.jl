module TestBlockModel
  using Test
  using EcologicalNetworks
  using Distributions: Categorical

  labels = rand(Categorical([0.1 for i in 1:10]), 50)
  @test typeof(rand(BlockModel(labels, rand(50,50)))) <: UnipartiteNetwork
  @test richness(rand(BlockModel(labels, rand(50,50)))) == 50

end

