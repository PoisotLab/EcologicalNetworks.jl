module TestCentrality
  using Base.Test
  using EcologicalNetwork

  A = UnipartiteNetwork(map(Bool, [0.0 1.0 0.0 0.0; 0.0 0.0 0.0 1.0; 0.0 1.0 0.0 0.0; 0.0 0.0 0.0 0.0]))

  c_1_1 = centrality_katz(A, a=0.1, k=1)
  c_2_1 = centrality_katz(A, a=0.2, k=1)
  c_1_2 = centrality_katz(A, a=0.1, k=2)

  e_c_1_1 = [0.0 2.0/3.0 0.0 1.0/3.0]
  e_c_2_1 = [0.0 2.0/3.0 0.0 1.0/3.0]
  e_c_1_2 = [0.0 0.625 0.0 0.374]

  for i = eachindex(species(A))
    si = species(A)[i]
    @test e_c_1_1[i] ≈ c_1_1[si] atol=0.01
    @test e_c_2_1[i] ≈ c_2_1[si] atol=0.01
    @test e_c_1_2[i] ≈ c_1_2[si] atol=0.01
  end

  # Test network

  N = UnipartiteNetwork([
    false true true false false;
    false false false true false;
    false false false true false;
    false false false false true;
    false false false false false
  ])

  @test centrality_degree(N)["s1"] ≈ 2/3
  @test centrality_degree(N)["s2"] ≈ 2/3
  @test centrality_degree(N)["s3"] ≈ 2/3
  @test centrality_degree(N)["s4"] ≈ 1.0
  @test centrality_degree(N)["s5"] ≈ 1/3

  @test centrality_closeness(N)["s1"] ≈ 4 / 7
  @test centrality_closeness(N)["s2"] ≈ 1.3333333333333
  @test centrality_closeness(N)["s3"] ≈ 1.3333333333333
  @test centrality_closeness(N)["s4"] ≈ 4 / 1
  @test centrality_closeness(N)["s5"] ≈ 0.0

end
