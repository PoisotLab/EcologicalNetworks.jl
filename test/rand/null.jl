module TestNullModels
  using Test
  using EcologicalNetworks

  # Generate some data

  A = [true true false; true true true; false true false]
  N = UnipartiteNetwork(A)

  n1 = null1(N)
  n2 = null2(N)
  n4 = null4(N)
  n3o = null3out(N)
  n3i = null3in(N)

  @test typeof(n1) <: UnipartiteProbabilisticNetwork
  @test typeof(n2) <: UnipartiteProbabilisticNetwork
  @test typeof(n4) <: UnipartiteProbabilisticNetwork
  @test typeof(n3o) <: UnipartiteProbabilisticNetwork
  @test typeof(n3i) <: UnipartiteProbabilisticNetwork

  B = BipartiteNetwork(A)
  @test typeof(null1(B)) <: BipartiteProbabilisticNetwork
  @test typeof(null2(B)) <: BipartiteProbabilisticNetwork
    @test typeof(null2mult(B)) <: BipartiteProbabilisticNetwork
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

  # Null model 2 (mult)
  @test n4[1,3] ≈ 2.0 * 1.0 / 36.0
  @test n4[2,2] ≈ 3.0 * 3.0 / 36.0
  @test n4[1,1] ≈ 2.0 * 2.0 / 36.0

  # Null model 3
  @test n3o[1,1] ≈ 2.0 / 3.0
  @test n3o[2,1] ≈ 1.0
  @test n3o[3,3] ≈ 1.0 / 3.0

  @test n3i[1,1] ≈ 2.0 / 3.0
  @test n3i[2,2] ≈ 1.0
  @test n3i[3,3] ≈ 1.0 / 3.0

  # filter

  C = copy(B)
  C[1,1] = false  # remove one interaction
  # make version of the network with the first interaction removed

  # test if the zoo of B is the same as the result of the filter of C at (1,1)
  @test linearfilter(C)[1,1] ≈ linearfilterzoo(B)[1,1]
  @test linearfilter(C)[1,1] != linearfilter(B)[1,1]

end
