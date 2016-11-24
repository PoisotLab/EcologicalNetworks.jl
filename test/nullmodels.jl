module TestNullModels
  using Base.Test
  using EcologicalNetwork

  # Generate some data

  A = [true true false; true true true; false true false]
  N = UnipartiteNetwork(A)

  n1 = null1(N)
  n2 = null2(N)
  n3o = null3out(N)
  n3i = null3in(N)

  @test typeof(n1) == UnipartiteProbaNetwork
  @test typeof(n2) == UnipartiteProbaNetwork
  @test typeof(n3o) == UnipartiteProbaNetwork
  @test typeof(n3i) == UnipartiteProbaNetwork

  B = BipartiteNetwork(A)
  @test typeof(null1(B)) == BipartiteProbaNetwork
  @test typeof(null2(B)) == BipartiteProbaNetwork
  @test typeof(null3in(B)) == BipartiteProbaNetwork
  @test typeof(null3out(B)) == BipartiteProbaNetwork

  # Null model 1
  @test_approx_eq n1[1,1] 6.0 / 9.0
  @test_approx_eq n1[2,2] 6.0 / 9.0
  @test_approx_eq n1[3,3] 6.0 / 9.0

  # Null model 2
  @test_approx_eq n2[1,3] 0.5
  @test_approx_eq n2[2,2] 1.0
  @test_approx_eq n2[1,1] 2.0 / 3.0

  # Null model 3
  @test_approx_eq n3o[1,1] 2.0 / 3.0
  @test_approx_eq n3o[2,1] 1.0
  @test_approx_eq n3o[3,3] 1.0 / 3.0

  @test_approx_eq n3i[1,1] 2.0 / 3.0
  @test_approx_eq n3i[2,2] 1.0
  @test_approx_eq n3i[3,3] 1.0 / 3.0

end
