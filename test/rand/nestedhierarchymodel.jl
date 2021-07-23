module TestNHModel
  using Test
  using EcologicalNetworks

  @test typeof(rand(NestedHierarchyModel(10, 20))) <: UnipartiteNetwork

  #@test richness(nestedhierarchymodel(10, 20)) == 10
  #@test richness(nestedhierarchymodel(10, 49)) == 10
  #@test richness(nestedhierarchymodel(20, 20)) == 20

  # Need to design test, and nh model doesnt have any argument error yet.
  # @test_throws ArgumentError nestedhierarchymodel(10, 99)
  # @test_throws ArgumentError nestedhierarchymodel(10, 51)
  # @test_throws ArgumentError nestedhierarchymodel(10, 50)
  # @test_throws ArgumentError nestedhierarchymodel(10, 200)
  # @test_throws ArgumentError nestedhierarchymodel(10, 0)

  #empirical_foodweb = EcologicalNetworks.nz_stream_foodweb()[1]
  #@test typeof(nichemodel(empirical_foodweb)) <: UnipartiteNetwork

end
