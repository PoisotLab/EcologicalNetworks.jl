module TestCascadeModel
  using Test
  using RandomEcologicalNetworks
  using EcologicalNetworks

  @test typeof(cascademodel(10, 0.1)) <: UnipartiteNetwork

  @test richness(cascademodel(10, 0.1)) == 10
  @test richness(cascademodel(10, 0.2)) == 10
  @test richness(cascademodel(20, 0.1)) == 20

  @test_throws ArgumentError cascademodel(10, 0.9)
  @test_throws ArgumentError cascademodel(10, 0.7)
  @test_throws ArgumentError cascademodel(-10, 0.1)

  empirical_foodweb = EcologicalNetworks.nz_stream_foodweb()[1]
  @test typeof(cascademodel(empirical_foodweb)) <: UnipartiteNetwork

end
