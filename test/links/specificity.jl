module TestSpecificityFunctions
  using Test
  using EcologicalNetwork

  # specificity

  @test EcologicalNetwork.pdi(vec([1.0 0.0 0.0])) ≈ 1.0
  @test EcologicalNetwork.pdi(vec([0.0 1.0 0.0])) ≈ 1.0
  @test EcologicalNetwork.pdi(vec([0.0 0.2 0.0])) ≈ 1.0

  N = BipartiteNetwork(eye(Bool, 10))
  @test specificity(N)[species(N; dims=1)[1]] ≈ 1.0
  N = BipartiteQuantitativeNetwork(eye(Float64, 10))
  @test specificity(N)[species(N; dims=1)[1]] ≈ 1.0

end
