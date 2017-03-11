module TestPaths
  using Base.Test
  using EcologicalNetwork

  # Generate some data

  A = UnipartiteProbaNetwork([0.0 0.1; 0.2 0.8])

  P = number_of_paths(A, n=2)

  @test_approx_eq P[1,1] 0.02
  @test_approx_eq P[1,2] 0.08
  @test_approx_eq P[2,2] 0.66

  # Shortest paths
  u = unipartitemotifs()
  d = shortest_path(u[:S1], nmax=200)
  @test d == [0 1 2; 0 0 1; 0 0 0]

end
