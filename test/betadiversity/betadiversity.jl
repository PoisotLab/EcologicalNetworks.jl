module TestBetaDiv
  using Test
  using EcologicalNetwork

  # Matrices of unequal sizes

  @test_throws BoundsError betadiversity(BipartiteProbaNetwork(eye(4)), BipartiteProbaNetwork(eye(5)))
  @test_throws TypeError betadiversity(BipartiteProbaNetwork(eye(4)), UnipartiteProbaNetwork(eye(4)))

  # Sum for custom ProbaSet test

  @test sum(EcologicalNetwork.BetaSet(0.0, 0.0, 0.0)) == 0.0

  # Equal matrices

  N = BipartiteNetwork(eye(Bool, 10))

  S = betadiversity(N, N)
  @test S.a == 10.0
  @test S.b == 0.0
  @test S.c == 0.0

  @test jaccard(S) == 1.0
  @test whittaker(S) == 0.0
  @test sorensen(S) == 1.0

  # Different matrices

  A = BipartiteProbaNetwork([1.0 0.3 0.0; 0.2 0.8 1.0; 0.2 0.4 0.3])
  B = BipartiteProbaNetwork([1.0 0.8 0.2; 0.4 0.6 0.7; 0.1 0.7 0.6])

  S = betadiversity(A, B)

  @test jaccard(S) ≈ 0.4715189873417721
  @test whittaker(S) ≈ 0.35913978494623655
  @test sorensen(S) ≈ 0.6408602150537633

  # Examples using simple sets
  set_s = EcologicalNetwork.BetaSet(2.0, 0.0, 0.0)
  set_d = EcologicalNetwork.BetaSet(0.0, 1.0, 1.0)
  set_e = EcologicalNetwork.BetaSet(1.0, 1.0, 1.0)

  # Whittaker
  @test whittaker(set_s) ≈ 0.0
  @test whittaker(set_d) ≈ 1.0
  @test whittaker(set_e) ≈ 0.5

  # Gaston
  @test gaston(set_s) ≈ 0.0
  @test gaston(set_d) ≈ 1.0
  @test gaston(set_e) ≈ 2.0/3.0

  # Williams
  @test williams(set_s) ≈ 0.0
  @test williams(set_d) ≈ 0.5
  @test williams(set_e) ≈ 1.0/3.0

  # Lande
  @test lande(set_s) ≈ 0.0
  @test lande(set_d) ≈ 1.0
  @test lande(set_e) ≈ 1.0

  # Ruggiero
  @test ruggiero(set_s) ≈ 1.0
  @test ruggiero(set_d) ≈ 0.0
  @test ruggiero(set_e) ≈ 0.5

  # Harrison
  @test harrison(set_s) ≈ 0.0
  @test harrison(set_d) ≈ 1.0
  @test harrison(set_e) ≈ 0.5

  # Harte-Kinzig
  @test hartekinzig(set_s) ≈ 0.0
  @test hartekinzig(set_d) ≈ 1.0
  @test hartekinzig(set_e) ≈ 0.5

end
