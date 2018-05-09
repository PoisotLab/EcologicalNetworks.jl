module TestData
  using Base.Test
  using EcologicalNetwork

  # Catlins
  #ttc = thompson_townsend_catlins()
  #@test typeof(ttc) <: UnipartiteNetwork
  #@test richness(ttc) == 49
  #@test degree_out(ttc)["Unidentified detritus"] == 0

  #fc96 = fonseca_ganade_1996()
  #@test typeof(fc96) <: AbstractBipartiteNetwork
  #@test typeof(fc96) <: QuantitativeNetwork
  #@test typeof(fc96) <: BipartiteQuantitativeNetwork
  #@test richness(fc96) == 16+25

  #mc93 = mccullen_1993()
  #@test typeof(mc93) <: AbstractBipartiteNetwork
  #@test richness(mc93) == 159
  #@test richness(mc93,1) == 54
  #@test richness(mc93,2) == 105

end
