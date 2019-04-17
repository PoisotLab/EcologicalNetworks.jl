module TestQuantitativeBersier
using Test
using EcologicalNetworks

  N = chesapeake_bay()
  original_taxa = Dict(1 => "phytoplankton", 2 => "bacteria in suspended poc", 3 =>
  "bacteria in sediment poc", 4 => "benthic diatoms", 5 => "free bacteria", 6 =>
  "heterotrophic microflagel", 7 => "ciliates", 8 => "zooplankton", 9 =>
  "ctenophores", 10 => "sea nettle", 11 => "other suspension feeders", 12 => "mya arenaria", 13 => "oysters",
  14 => "other polychaetes", 15 => "nereis", 16 =>
  "macoma spp.", 17 => "meiofauna", 18 => "crustacean deposit feeder",
  19 => "blue crab", 20 => "fish larvae", 21 => "alewife & blue herring",
  22 => "bay anchovy", 23 => "menhaden", 24 => "shad", 25 => "croaker",
  26 => "hogchoker", 27 => "spot", 28 => "white perch", 29 => "catfish",
  30 => "bluefish", 31 => "weakfish", 32 => "summer flounder",
  33 => "striped bass", 34 => "dissolved organic carbon",
  35 => "suspended particulate org", 36 => "sediment particulate orga",
  37 => "Input", 38 => "Output", 39 => "Respiration")

  ed1 = equivalent_degree(N, dims=1)
  ed2 = equivalent_degree(N, dims=2)

  @info ed1[original_taxa[33]]
  @info ed2[original_taxa[33]]
  @info ed1[original_taxa[19]]
  @info ed2[original_taxa[19]]

  @test ed2[original_taxa[33]] ≈ 0.0
  @test ed1[original_taxa[33]] ≈ 2.52

  @test ed2[original_taxa[19]] ≈ 1.05
  @test ed1[original_taxa[19]] ≈ 4.12

end
