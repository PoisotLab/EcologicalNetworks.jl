module TestNullModels
  using Test
  using EcologicalNetworks

  # Generate some data

  A = [true true false; true true true; false true false]
  N = UnipartiteNetwork(A)

  n1 = null1(N)
  n2 = null2(N)
  n3o = null3out(N)
  n3i = null3in(N)

  @test typeof(n1) <: UnipartiteProbabilisticNetwork
  @test typeof(n2) <: UnipartiteProbabilisticNetwork
  @test typeof(n3o) <: UnipartiteProbabilisticNetwork
  @test typeof(n3i) <: UnipartiteProbabilisticNetwork

  B = BipartiteNetwork(A)
  @test typeof(null1(B)) <: BipartiteProbabilisticNetwork
  @test typeof(null2(B)) <: BipartiteProbabilisticNetwork
  @test typeof(null3in(B)) <: BipartiteProbabilisticNetwork
  @test typeof(null3out(B)) <: BipartiteProbabilisticNetwork

  # Null model 1
  @test n1[1,1] ≈ 6.0 / 9.0
  @test n1[2,2] ≈ 6.0 / 9.0
  @test n1[3,3] ≈ 6.0 / 9.0

  # Null model 2
  @test n2[1,3] ≈ 0.5
  @test n2[2,2] ≈ 1.0
  @test n2[1,1] ≈ 2.0 / 3.0

  # Null model 3
  @test n3o[1,1] ≈ 2.0 / 3.0
  @test n3o[2,1] ≈ 1.0
  @test n3o[3,3] ≈ 1.0 / 3.0

  @test n3i[1,1] ≈ 2.0 / 3.0
  @test n3i[2,2] ≈ 1.0
  @test n3i[3,3] ≈ 1.0 / 3.0

  # filter

  # make version of the network with the first interaction removed
  B = copy(A)
  B[1,1] = false
  Nchanged = UnipartiteNetwork(B)
  # test if the zoo of A is the same as the result of the filter of B at (1,1)
  @test linearfilter(B)[1,1] == linearfilterzoo(A)[1,1]


end
