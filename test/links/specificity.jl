module TestSpecificityFunctions
  using Test
  using EcologicalNetworks
  using LinearAlgebra

  # specificity

  @test EcologicalNetwork.pdi(vec([1.0 0.0 0.0])) ≈ 1.0
  @test EcologicalNetwork.pdi(vec([0.0 1.0 0.0])) ≈ 1.0
  @test EcologicalNetwork.pdi(vec([0.0 0.2 0.0])) ≈ 1.0

  N = BipartiteNetwork(Matrix(I, (10,10)))
  @test specificity(N)[species(N; dims=1)[1]] ≈ 1.0
  N = BipartiteQuantitativeNetwork(Matrix{Float64}(I, (10,10)))
  @test specificity(N)[species(N; dims=1)[1]] ≈ 1.0

end
