module TestFreeSpecies
  using Base.Test
  using EcologicalNetwork

  # Generate some data

  A = UnipartiteProbabilisticNetwork([1.0 0.0 0.0; 0.0 0.1 0.0; 0.0 0.0 0.1])
  @test isdegenerate(A)

  B = BipartiteProbabilisticNetwork([1.0 1.0 1.0 0.1; 0.0 1.0 0.1 0.0; 0.5 1.0 0.0 0.0])
  @test !isdegenerate(B)

  C = UnipartiteNetwork(zeros(Bool, (4,4)))
  @test isdegenerate(C)

  D = UnipartiteNetwork(eye(Bool, 4))
  @test isdegenerate(D)

  #=

  # Unipartite case
  @test free_species(A) ≈ 3.0

  # Make bipartite unipartite case
  @test free_species(B) ≈ 0.9

  # No predecessors and successors
  A = make_unipartite(BipartiteProbabilisticNetwork([1.0 0.4 0.3 0.8; 0.0 0.2 0.3 0.6; 0.1 0.2 0.4 0.2]))

  no_succ = species_has_no_successors(A)
  no_pred = species_has_no_predecessors(A)

  @test no_succ[1] == 0.0
  @test no_succ[4] == 1.0

  @test no_pred[1] == 1.0
  @test no_pred[4] == 0.0

  =#

end
