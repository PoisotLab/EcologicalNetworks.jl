module TestSwaps
  using Base.Test
  using EcologicalNetwork

  # test the validity of a series of swaps
  @test EcologicalNetwork.is_valid([0 0; 1 1], [0 0; 1 1], :fill)
  @test EcologicalNetwork.is_valid([0 1; 0 1], [0 0; 1 1], :fill)
  @test EcologicalNetwork.is_valid([1 1; 1 1], [1 1; 1 1], :fill)
  @test !EcologicalNetwork.is_valid([1 1; 1 1], [1 1; 1 0], :fill)

  @test EcologicalNetwork.is_valid([0 0; 1 1], [0 0; 1 1], :degree)
  @test EcologicalNetwork.is_valid([1 0; 0 1], [0 1; 1 0], :degree)

  @test EcologicalNetwork.is_valid([0 0; 1 1], [0 0; 1 1], :generality)
  @test EcologicalNetwork.is_valid([0 0; 1 1], [0 0; 1 1], :vulnerability)

  # test the ability to generate swaps
  a = [true true; false true]
  b = EcologicalNetwork.inner_swap(a, constraint=:fill)
  @test EcologicalNetwork.is_valid(a, b, :fill)

  # test the swap function
  a = BipartiteNetwork([true true false; false true false; true true true])
  b = shuffle(a, constraint=:degree, swapsize=2)
  @test links(b) == links(a)
  @test EcologicalNetwork.is_valid(a.A, b.A, :degree)

  # test the swap function
  a = UnipartiteNetwork([true true false; false true false; true true true])
  b = shuffle(a, constraint=:degree, swapsize=2)
  @test links(b) == links(a)
  @test EcologicalNetwork.is_valid(a.A, b.A, :degree)

end
