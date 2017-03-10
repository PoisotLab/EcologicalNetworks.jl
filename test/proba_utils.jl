module TestProbaUtilities
  using Base.Test
  using EcologicalNetwork
  using NamedArrays

  # Probabilities must be floating point
  @test_throws AssertionError EcologicalNetwork.@checkprob 1

  # Probabilities must be in 0-1
  @test_throws AssertionError EcologicalNetwork.@checkprob -0.2
  @test_throws AssertionError EcologicalNetwork.@checkprob 1.2

  # Base proba function
  @test i_esp(0.2) == 0.2
  @test_approx_eq i_var(0.4) 0.4*0.6
  @test_approx_eq a_var(NamedVector(vec([0.2, 0.4, 0.3]))) 0.61

  # Mutltiplication of Bernoulli events
  @test_approx_eq m_var(NamedVector(vec([1.0 0.0]))) 0.0
  @test_approx_eq m_var(NamedVector(vec([1.0 1.0]))) 0.0
  @test_approx_eq m_var(NamedVector(vec([1.0 0.1]))) 0.09
  @test_approx_eq m_var(NamedVector(vec([0.5 0.5]))) 0.1875

end
