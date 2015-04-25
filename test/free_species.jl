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

  # No predecessors and successors
  A = make_unipartite([1.0 0.4 0.3 0.8; 0.0 0.2 0.3 0.6; 0.1 0.2 0.4 0.2])

  no_succ = species_has_no_successors(A)
  no_pred = species_has_no_predecessors(A)

  @test no_succ[1] == 0.0
  @test no_succ[4] == 1.0

  @test no_pred[1] == 1.0
  @test no_pred[4] == 0.0

end
