module TestDegreeFunctions
  using Base.Test
  using EcologicalNetwork

  # Generate some data

  N = UnipartiteProbaNetwork([0.22 0.4; 0.3 0.1])

  d_in = vec([0.52 0.5])
  d_out = vec([0.62 0.4])
  d_tot = vec([1.14 0.9])

  Din = degree_in(N)
  Dout = degree_out(N)
  Dtot = degree(N)

  Dov = degree_out_var(N)
  @test Dov[2] ≈ 0.3

  Div = degree_in_var(N)
  @test Div[1] ≈ 0.3816

  Dv = degree_var(N)
  @test Dv[2] ≈ 0.63

  for i in 1:2
    @test d_in[i] ≈ Din[i]
    @test d_out[i] ≈ Dout[i]
    @test d_tot[i] ≈ Dtot[i]
  end

  @test link_number(BipartiteQuantiNetwork(eye(Int64, 10))) ≈ 10

  # specificity

  @test EcologicalNetwork.pdi(vec([1.0 0.0 0.0])) ≈ 1.0
  @test EcologicalNetwork.pdi(vec([0.0 1.0 0.0])) ≈ 1.0
  @test EcologicalNetwork.pdi(vec([0.0 0.2 0.0])) ≈ 1.0

  @test specificity(BipartiteNetwork(eye(Bool, 10)))[1] ≈ 1.0
  @test specificity(BipartiteQuantiNetwork(eye(Float64, 10)))[1] ≈ 1.0

end

