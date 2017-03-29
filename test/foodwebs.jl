module TestFoodWebs
  using Base.Test
  using EcologicalNetwork

  # test the positions function with bool and bit arrays
  @test EcologicalNetwork.positions(vec([true false true])) == vec([1, 3])
  @test EcologicalNetwork.positions(vec([5 4 5]) .> 4) == vec([1, 3])

  # test trophic levels on motifs
  s1 = unipartitemotifs()[:S1]
  @test maximum(fractional_trophic_level(s1)) == 3.0
  @test maximum(trophic_level(s1)) == 3.0

  s2 = unipartitemotifs()[:S2]
  @test minimum(fractional_trophic_level(s1)) == 1.0
  @test minimum(trophic_level(s1)) == 1.0

  # test on a quantitative bipartite network
  @test bluthgen() |> make_unipartite |> trophic_level |> minimum == 1.0
  @test bluthgen() |> make_unipartite |> trophic_level |> maximum == 2.0

  # trophic positions
  @test foodweb_position(s1)[1] == :top
  @test foodweb_position(s1)[2] == :intermediate
  @test foodweb_position(s1)[3] == :bottom


  # test that the results are the same with and without loops
  A = unipartitemotifs()[:S1]
  @test foodweb_position(A, loops=false)[1] == :top
  @test foodweb_position(A, loops=true)[1] == :top

end
