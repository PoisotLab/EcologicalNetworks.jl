module TestMakeUnipartite
  using Base.Test
  using EcologicalNetwork

  # Generate some data

  N = BipartiteProbaNetwork([1.0 1.0; 1.0 1.0])
  M = make_unipartite(N)

  @test typeof(M) == UnipartiteProbaNetwork

  @test M[3,1] == 0.0
  @test M[1,4] == 1.0
  
  N = BipartiteNetwork([true true; true true])
  M = make_unipartite(N)

  @test typeof(M) == UnipartiteNetwork

end
