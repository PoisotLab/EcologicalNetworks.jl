module TestNestedness
  using Base.Test
  using ProbabilisticNetwork

  # Generate some data

  A = [1.0 0.0 0.0; 0.0 0.1 0.0; 0.0 0.0 0.1]
  B = [1.0 1.0 1.0; 1.0 0.1 0.0; 1.0 0.0 0.0]
  C = [1.0 1.0 1.0; 1.0 0.1 0.3; 0.4 0.2 0.0]
  D = [1.0 1.0 1.0; 0.0 0.1 1.0; 0.0 0.0 1.0]

  @test_approx_eq nestedness(A)[1] 0.0
  @test_approx_eq nestedness(B)[1] 1.0
  @test_approx_eq nestedness(C)[1] 0.9153846153846155

end
