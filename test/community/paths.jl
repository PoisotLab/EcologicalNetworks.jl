module TestPaths
  using Base.Test
  using EcologicalNetwork

  # Generate some data

  A = UnipartiteProbabilisticNetwork([0.0 0.1; 0.2 0.8])

  P = number_of_paths(A, n=2)
  
  @test P[1,1] ≈ 0.02
  @test P[1,2] ≈ 0.08
  @test P[2,2] ≈ 0.66

end
