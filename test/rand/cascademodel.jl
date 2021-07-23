module TestCascadeModel
  using Test
  using EcologicalNetworks

  @test typeof(rand(CascadeModel(10, 0.1))) <: UnipartiteNetwork

  @test richness(rand(CascadeModel(10, 0.1))) == 10
  @test richness(rand(CascadeModel(10, 0.2))) == 10
  @test richness(rand(CascadeModel(20, 0.1))) == 20
  
  @test richness(rand(CascadeModel((10, 0.1)))) == 10
  @test richness(rand(CascadeModel((10, 10)))) == 10

  @test_throws ArgumentError rand(CascadeModel(10, 0.9))
  @test_throws ArgumentError rand(CascadeModel(10, 0.7))
  @test_throws ArgumentError rand(CascadeModel(-10, 0.1))

  empirical_foodweb = EcologicalNetworks.nz_stream_foodweb()[1]
  @test typeof(CascadeModel(empirical_foodweb)) <: UnipartiteNetwork

end
