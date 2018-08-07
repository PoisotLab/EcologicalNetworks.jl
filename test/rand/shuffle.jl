module TestSwaps
  using Test
  using EcologicalNetworks
  using Random

  N = convert(BinaryNetwork, web_of_life("A_HP_001"))
  Ud = shuffle(N; number_of_swaps=10, constraint=:degree)
  Uf = shuffle(N; number_of_swaps=10, constraint=:fill)
  Ui = shuffle(N; number_of_swaps=10, constraint=:vulnerability)
  Uo = shuffle(N; number_of_swaps=10, constraint=:generality)

  @test links(N) == links(Ud)
  @test links(N) == links(Uf)
  @test links(N) == links(Ui)
  @test links(N) == links(Uo)

  @test degree(N) == degree(Ud)
  @test degree(N; dims=1) == degree(Ud; dims=1)
  @test degree(N; dims=2) == degree(Ud; dims=2)
  @test degree(N; dims=1) == degree(Uo; dims=1)
  @test degree(N; dims=2) == degree(Ui; dims=2)

  N = convert(BinaryNetwork, nz_stream_foodweb()[1])
  Ud = shuffle(N; number_of_swaps=10, constraint=:degree)
  Uf = shuffle(N; number_of_swaps=10, constraint=:fill)
  Ui = shuffle(N; number_of_swaps=10, constraint=:vulnerability)
  Uo = shuffle(N; number_of_swaps=10, constraint=:generality)

  @test links(N) == links(Ud)
  @test links(N) == links(Uf)
  @test links(N) == links(Ui)
  @test links(N) == links(Uo)

  @test degree(N) == degree(Ud)
  @test degree(N; dims=1) == degree(Ud; dims=1)
  @test degree(N; dims=2) == degree(Ud; dims=2)
  @test degree(N; dims=1) == degree(Uo; dims=1)
  @test degree(N; dims=2) == degree(Ui; dims=2)

end
