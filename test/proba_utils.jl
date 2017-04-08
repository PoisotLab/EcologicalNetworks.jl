module TestProbaUtilities
  using Base.Test
  using EcologicalNetwork

  # Probabilities must be floating point
  @test_throws AssertionError EcologicalNetwork.@checkprob 1

  # Probabilities must be in 0-1
  @test_throws AssertionError EcologicalNetwork.@checkprob -0.2
  @test_throws AssertionError EcologicalNetwork.@checkprob 1.2

  # Base proba function
  @test i_esp(0.2) == 0.2
  @test i_var(0.4) ≈ 0.4*0.6
  @test a_var([0.2, 0.4, 0.3]) ≈ 0.61

  # Mutltiplication of Bernoulli events
  @test m_var([1.0 0.0]) ≈ 0.0
  @test m_var([1.0 1.0]) ≈ 0.0
  @test m_var([1.0 0.1]) ≈ 0.09
  @test m_var([0.5 0.5]) ≈ 0.1875

end
