module TestFoodWebs
  using Test
  using EcologicalNetworks

  # test trophic levels on motifs
  s1 = unipartitemotifs()[:S1]
  s1_ftl = trophic_level(s1)
  s1_tl = distance_to_producer(s1)
  @test maximum(values(s1_ftl)) ≈ 3
  @test maximum(values(s1_tl)) ≈ 3.0
  @test s1_ftl[:a] ≈ 3
  @test s1_ftl[:b] ≈ 2
  @test s1_ftl[:c] ≈ 1

  s2 = unipartitemotifs()[:S2]
  @test minimum(values(trophic_level(s1))) ≈ 1.0
  @test minimum(values(distance_to_producer(s1))) == 1.0

  # test on a quantitative bipartite network
  @test web_of_life("A_HP_002") |>
    x -> convert(BinaryNetwork, x) |> x -> convert(UnipartiteNetwork, x) |>
    trophic_level |> values |> minimum |> x -> x == 1.0
  @test web_of_life("A_HP_002") |>
    x -> convert(BinaryNetwork, x) |> x -> convert(UnipartiteNetwork, x) |>
    trophic_level |> values |> maximum |> x -> x == 2.0

end
