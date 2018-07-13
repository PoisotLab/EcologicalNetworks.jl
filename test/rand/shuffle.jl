module TestSwaps
  using Base.Test
  using EcologicalNetwork

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
  @test degree(N,1) == degree(Ud,1)
  @test degree(N,2) == degree(Ud,2)
  @test degree(N,1) == degree(Uo,1)
  @test degree(N,2) == degree(Ui,2)

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
  @test degree(N,1) == degree(Ud,1)
  @test degree(N,2) == degree(Ud,2)
  @test degree(N,1) == degree(Uo,1)
  @test degree(N,2) == degree(Ui,2)

end
