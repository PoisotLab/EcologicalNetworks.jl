module TestUtilities
  using Base.Test
  using ProbabilisticNetwork

  # Probabilities must be floating point
  @test_throws TypeError ProbabilisticNetwork.@checkprob Int64(1)

  # Probabilities must be in 0-1
  #@test_throws DomainError ProbabilisticNetwork.@checkprob -0.2
  #@test_throws DomainError ProbabilisticNetwork.@checkprob 1.2

end
