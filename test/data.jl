module TestData
  using Base.Test
  using EcologicalNetwork

  # Catlins
  ttc = thompson_townsend_catlins()
  @test typeof(ttc) <: UnipartiteNetwork
  @test richness(ttc) == 49

end
