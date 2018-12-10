module TestNicheModel
  using Test
  using RandomEcologicalNetworks
  using EcologicalNetworks

  @test typeof(nichemodel(10, 20)) <: UnipartiteNetwork

  @test richness(nichemodel(10, 20)) == 10
  @test richness(nichemodel(10, 49)) == 10
  @test richness(nichemodel(20, 20)) == 20

  @test_throws ArgumentError nichemodel(10, 99)
  @test_throws ArgumentError nichemodel(10, 51)
  @test_throws ArgumentError nichemodel(10, 50)
  @test_throws ArgumentError nichemodel(10, 200)
  @test_throws ArgumentError nichemodel(10, 0)

  empirical_foodweb = EcologicalNetworks.nz_stream_foodweb()[1]
  @test typeof(nichemodel(empirical_foodweb)) <: UnipartiteNetwork

end
