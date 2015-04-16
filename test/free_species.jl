module TestFreeSpecies
  using Base.Test
  using ProbabilisticNetwork

  # Generate some data

  A = [1.0 0.0 0.0; 0.0 0.1 0.0; 0.0 0.0 0.1]
  B = [1.0 1.0 1.0 0.1; 0.0 1.0 0.1 0.0; 0.5 1.0 0.0 0.0]

  # Unipartite case
  @test_approx_eq free_species(A) 3.0

  # Make bipartite unipartite case
  @test_approx_eq free_species(B) 0.9

end
