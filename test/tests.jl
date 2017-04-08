module TestStatsTests
  using Base.Test
  using EcologicalNetwork

  # Generate some data
  A = BipartiteNetwork([true true; false true])

  X = map(x -> BipartiteNetwork([false false; false true]), 1:10)

  # mock NODF output
  output = test_network_property(A, x -> nodf(x)[3], X)

  @test output.pval ≈ 0.00
  @test output.test == :greater
  @test output.v0 ≈ 1.0
  @test output.n == 10

end
