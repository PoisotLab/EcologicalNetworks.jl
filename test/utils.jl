module TestUtilities
  using Base.Test
  using EcologicalNetwork

  # Probabilities must be floating point
  @test_throws TypeError EcologicalNetwork.@checkprob 1

  # Probabilities must be in 0-1
  @test_throws DomainError EcologicalNetwork.@checkprob -0.2
  @test_throws DomainError EcologicalNetwork.@checkprob 1.2

  # Function to make thresholded or binary networks
  A = [0.2 0.05; 1.0 0.0]

  bin = make_binary(A)
  @test bin[1, 1] == 1.0
  @test bin[2, 2] == 0.0

  thr = make_threshold(A, 0.1)
  @test thr[1, 1] == 1.0
  @test thr[1, 2] == 0.0

  @test_throws DomainError make_threshold(A, 1.0)

  # Base proba function
  @test i_esp(0.2) == 0.2
  @test_approx_eq i_var(0.4) 0.4*0.6
  @test_approx_eq a_var([0.2, 0.4, 0.3]) 0.61

  # Remove the diagonal
  A = [1.0 1.0 1.0; 0.0 0.0 0.0; 1.0 1.0 1.0]
  @test nodiag(A)[2,2] == 0.0
  @test nodiag(A)[3,3] == 0.0
  @test nodiag(A)[1,1] == 0.0

  # Mutltiplication of Bernoulli events
  @test_approx_eq m_var([1.0 0.0]) 0.0
  @test_approx_eq m_var([1.0 1.0]) 0.0
  @test_approx_eq m_var([1.0 0.1]) 0.09
  @test_approx_eq m_var([0.5 0.5]) 0.1875

end
