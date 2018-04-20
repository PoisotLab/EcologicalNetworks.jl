module TestData
  using Base.Test
  using EcologicalNetwork

  # Catlins
  ttc = thompson_townsend_catlins()
  @test typeof(ttc) <: UnipartiteNetwork
  @test richness(ttc) == 49
  @test degree_out(ttc)["Unidentified detritus"] == 0

  fc96 = fonseca_ganade_1996()
  @test typeof(fc96) <: AbstractBipartiteNetwork
  @test typeof(fc96) <: QuantitativeNetwork
  @test typeof(fc96) <: BipartiteQuantitativeNetwork
  @test richness(fc96) == 16+25

end
