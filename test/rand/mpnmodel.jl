module TestMPNModel
  using Test
  using EcologicalNetworks

  @test typeof(rand(MinimumPotentialNicheModel((10, 0.3, 0.2)))) <: UnipartiteNetwork

  @test richness(rand(MinimumPotentialNicheModel(10, 0.3, 0.2))) == 10
  @test richness(rand(MinimumPotentialNicheModel(10, 0.4, 0.5))) == 10
  @test richness(rand(MinimumPotentialNicheModel(20, 0.35, 0.9))) == 20

  # Need to design test, and nh model doesnt have any argument error yet.
  # @test_throws ArgumentError mnpmodel(10, 99)
  # @test_throws ArgumentError mnpmodel(10, 51)
  # @test_throws ArgumentError mnpmodel(10, 50)
  # @test_throws ArgumentError mnpmodel(10, 200)
  # @test_throws ArgumentError mnpmodel(10, 0)

  #empirical_foodweb = EcologicalNetworks.nz_stream_foodweb()[1]
  #@test typeof(nichemodel(empirical_foodweb)) <: UnipartiteNetwork

end
