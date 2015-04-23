module TestBetaDiv
  using Base.Test
  using ProbabilisticNetwork

  # Matrices of unequal sizes

  @test_throws BoundsError betadiversity(eye(4), eye(5))

  # Equal matrices

  S = betadiversity(eye(10), eye(10))
  @test S.a == 10.0
  @test S.b == 0.0
  @test S.c == 0.0

  @test jaccard(S) == 1.0
  @test whittaker(S) == 0.0
  @test sorensen(S) == 1.0

  # Different matrices
  A = [1.0 0.3 0.0; 0.2 0.8 1.0; 0.2 0.4 0.3]
  B = [1.0 0.8 0.2; 0.4 0.6 0.7; 0.1 0.7 0.6]

  S = betadiversity(A, B)

  @test_approx_eq jaccard(S) 0.4715189873417721
  @test_approx_eq whittaker(S) 0.35913978494623655
  @test_approx_eq sorensen(S) 0.6408602150537633

end
