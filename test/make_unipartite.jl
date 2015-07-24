module TestMakeUnipartite
  using Base.Test
  using EcologicalNetwork

  # Generate some data

  A = [1.0 1.0; 1.0 1.0]

  M = make_unipartite(A)

  @test M[3,1] == 0.0
  @test M[1,4] == 1.0
end
