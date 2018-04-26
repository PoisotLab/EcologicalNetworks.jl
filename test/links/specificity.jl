module TestSpecificityFunctions
  using Base.Test
  using EcologicalNetwork

  # specificity

  @test EcologicalNetwork.pdi(vec([1.0 0.0 0.0])) ≈ 1.0
  @test EcologicalNetwork.pdi(vec([0.0 1.0 0.0])) ≈ 1.0
  @test EcologicalNetwork.pdi(vec([0.0 0.2 0.0])) ≈ 1.0

  @test specificity(BipartiteNetwork(eye(Bool, 10)))[species(N,1)[1]] ≈ 1.0
  @test specificity(BipartiteQuantitativeNetwork(eye(Float64, 10)))[species(N,1)[1]] ≈ 1.0

end
