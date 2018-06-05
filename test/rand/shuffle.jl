module TestSwaps
  using Base.Test
  using EcologicalNetwork

  # test the swap function
  a = BipartiteNetwork([true true false; false true false; true true true])
  b = shuffle(a, constraint=:degree)
  @test links(b) == links(a)
  @test degree(b) == degree(a)

  # test the swap function
  a = UnipartiteNetwork([true true false; false true false; true true true])
  b = shuffle(a, constraint=:degree)
  @test links(b) == links(a)
  @test degree(b) == degree(a)

  a = UnipartiteNetwork([true true false; false true false; true true true])
  b = shuffle(a, constraint=:degree)
  @test links(b) == links(a)
  @test degree(b) == degree(a)

  a = UnipartiteNetwork([true true false; false true false; true true true])
  b = shuffle(a, constraint=:degree)
  @test links(b) == links(a)
  @test degree(b) == degree(a)

  a = UnipartiteNetwork([true true false; false true false; true true true])#
  b = shuffle(a, constraint=:fill)
  @test links(b) == links(a)

  a = UnipartiteNetwork([true true false; false true false; true true true])
  b = shuffle(a, constraint=:vulnerability)
  @test links(b) == links(a)
  @test degree(b,2) == degree(a,2)

  a = UnipartiteNetwork([true true false; false true false; true true true])
  b = shuffle(a, constraint=:generality)
  @test links(b) == links(a)
  @test degree(b,1) == degree(a,1)

end
