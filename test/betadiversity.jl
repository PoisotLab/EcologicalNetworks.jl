module TestBetaDiv
  using Base.Test
  using ProbabilisticNetwork

  # Matrices of unequal sizes

  @test_throws BoundsError betadiversity(eye(4), eye(5))

  # Sum for custom ProbaSet test

  @test sum(ProbabilisticNetwork.BetaSet(0.0, 0.0, 0.0)) == 0.0

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

  # Examples using simple sets
  set_s = ProbabilisticNetwork.BetaSet(2.0, 0.0, 0.0)
  set_d = ProbabilisticNetwork.BetaSet(0.0, 1.0, 1.0)
  set_e = ProbabilisticNetwork.BetaSet(1.0, 1.0, 1.0)

  # Whittaker
  @test_approx_eq whittaker(set_s) 0.0
  @test_approx_eq whittaker(set_d) 1.0
  @test_approx_eq whittaker(set_e) 0.5

  # Gaston
  @test_approx_eq gaston(set_s) 0.0
  @test_approx_eq gaston(set_d) 1.0
  @test_approx_eq gaston(set_e) 2.0/3.0

  # Williams
  @test_approx_eq williams(set_s) 0.0
  @test_approx_eq williams(set_d) 0.5
  @test_approx_eq williams(set_e) 1.0/3.0

  # Lande
  @test_approx_eq lande(set_s) 0.0
  @test_approx_eq lande(set_d) 1.0
  @test_approx_eq lande(set_e) 1.0

  # Ruggiero
  @test_approx_eq ruggiero(set_s) 1.0
  @test_approx_eq ruggiero(set_d) 0.0
  @test_approx_eq ruggiero(set_e) 0.5

  # Harrison
  @test_approx_eq harrison(set_s) 0.0
  @test_approx_eq harrison(set_d) 1.0
  @test_approx_eq harrison(set_e) 0.5

  # Harte-Kinzig
  @test_approx_eq hartekinzig(set_s) 0.0
  @test_approx_eq hartekinzig(set_d) 1.0
  @test_approx_eq hartekinzig(set_e) 0.5

end
