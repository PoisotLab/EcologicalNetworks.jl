module TestCentrality
  using Base.Test
  using ProbaNet

  # Generate some data

  A = [0.0 1.0 0.0 0.0; 0.0 0.0 0.0 1.0; 0.0 1.0 0.0 0.0; 0.0 0.0 0.0 0.0]

  c_1_1 = centrality_katz(A, a=0.1, k=1)
  c_2_1 = centrality_katz(A, a=0.2, k=1)
  c_1_2 = centrality_katz(A, a=0.1, k=2)

  e_c_1_1 = [0.0 2.0/3.0 0.0 1.0/3.0]
  e_c_2_1 = [0.0 2.0/3.0 0.0 1.0/3.0]
  e_c_1_2 = [0.0 0.625 0.0 0.374]

  for i = 1:3
    @test_approx_eq e_c_1_1[i] c_1_1[i]
    @test_approx_eq e_c_2_1[i] c_2_1[i]
    @test_approx_eq e_c_1_2[i] c_1_2[i]
  end

end
