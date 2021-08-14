module TestBlockModel
  using Test
  using EcologicalNetworks


  @test typeof(rand(BlockModel([i for i in 1:30]))) <: UnipartiteNetwork

  @test richness(rand(BlockModel([i for i in 1:10]))) == 10
  @test richness(rand(BlockModel([i for i in 1:20]))) == 20
  @test richness(rand(BlockModel([i for i in 1:30]))) == 30
  
end
