module TestData
  using Test
  using EcologicalNetworks

  all_wol = web_of_life()
  for wol in all_wol
    N = web_of_life(wol.ID)
    @test richness(N) == wol.Species
    @test links(N) == wol.Interactions
  end

  for n in nz_stream_foodweb()
    @test typeof(n) <: BinaryNetwork
    @test typeof(n) <: AbstractUnipartiteNetwork
  end

   p = pajek()
   @test typeof(p[:Chesapeake]) <: UnipartiteQuantitativeNetwork

end
