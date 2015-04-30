module TestPaths
  using Base.Test
  using ProbabilisticNetwork

  # Generate some data

  A = [0.0 0.1; 0.2 0.8]

  P = number_of_paths(A, n=2)

  @test_approx_eq P[1,1] 0.02
  @test_approx_eq P[1,2] 0.08
  @test_approx_eq P[2,2] 0.66

end
