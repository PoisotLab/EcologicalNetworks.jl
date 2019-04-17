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

  ches = chesapeake_bay()
  @test typeof(ches) <: AbstractUnipartiteNetwork
  @test typeof(ches) <: UnipartiteQuantitativeNetwork
  @test eltype(ches) == (Float64, String)
  @test ches["Input", "phytoplankton"] ≈ 522650.0000000
  @test ches["suspended particulate org", "sediment particulate orga"] ≈ 288606.4000000

end
