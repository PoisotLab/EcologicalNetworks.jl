module TestUtilities
  using Base.Test
  using ProbabilisticNetwork

  # Probabilities must be floating point
  @test_throws TypeError @checkprob Int64(1)

end
