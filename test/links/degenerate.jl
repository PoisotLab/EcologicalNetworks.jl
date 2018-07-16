module TestDegenerate
  using Test
  using EcologicalNetworks
  using LinearAlgebra

  # Generate some data

  A = UnipartiteProbabilisticNetwork([1.0 0.0 0.0; 0.0 0.1 0.0; 0.0 0.0 0.1])
  @test isdegenerate(A)

  B = BipartiteProbabilisticNetwork([1.0 1.0 1.0 0.1; 0.0 1.0 0.1 0.0; 0.5 1.0 0.0 0.0])
  @test !isdegenerate(B)

  C = UnipartiteNetwork(zeros(Bool, (4,4)))
  @test isdegenerate(C)

  D = UnipartiteNetwork(Matrix(I, (4,4)))
  @test isdegenerate(D)

  K = simplify(UnipartiteNetwork([false false false; false true true; false true true]))
  @test !isdegenerate(K)

  N = BipartiteNetwork([false false false; true false true; true true false])
  M = simplify(N)
  @test isdegenerate(N)
  @test !isdegenerate(M)

end
