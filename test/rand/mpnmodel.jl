module TestMPNModel
  using Test
  using EcologicalNetworks

  @test typeof(rand(MinimumPotentialNicheModel(10, 0.3, 0.2))) <: UnipartiteNetwork

  @test richness(rand(MinimumPotentialNicheModel(10, 0.3, 0.2))) == 10
  @test richness(rand(MinimumPotentialNicheModel(10, 0.4, 0.5))) == 10
  @test richness(rand(MinimumPotentialNicheModel(20, 0.35, 0.9))) == 20

  @test_throws ArgumentError MinimumPotentialNicheModel(10, 99, 0)
  @test_throws ArgumentError MinimumPotentialNicheModel(10, 51, 0)
  @test_throws ArgumentError MinimumPotentialNicheModel(10, 50, 0)
  @test_throws ArgumentError MinimumPotentialNicheModel(10, 200, 0)
  @test_throws ArgumentError MinimumPotentialNicheModel(10, 0, 0)

  empirical_foodweb = EcologicalNetworks.nz_stream_foodweb()[1]
  @test typeof(rand(MinimumPotentialNicheModel(empirical_foodweb))) <: UnipartiteNetwork

end
