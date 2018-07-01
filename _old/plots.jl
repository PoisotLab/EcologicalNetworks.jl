module TestPlots
  using Base.Test
  using EcologicalNetwork

  BP = BipartiteProbabilisticNetwork(rand(Float64, (3,3)))
  UP = UnipartiteProbabilisticNetwork(rand(Float64, (3,3)))
  BQ = BipartiteQuantitativeNetwork(rand(Float64, (3,3)))
  UQ = UnipartiteQuantitativeNetwork(rand(Float64, (3,3)))
  B = BipartiteNetwork(rand(Bool, (3,3)))
  U = nz_stream_foodweb()[1]
  
  for N in [BP, BQ, B]
    cl = circular_layout(N, steps=5);
    @test_nowarn circular_network_plot(cl...);
    cl = graph_layout(N, steps=5);
    @test_nowarn graph_network_plot(cl...);
  end

  for N in [UP, UQ, U]
    cl = circular_layout(N, steps=5);
    @test_nowarn circular_network_plot(cl...);
    cl = graph_layout(N, steps=5);
    @test_nowarn graph_network_plot(cl...);
    if typeof(N) <: BinaryNetwork
      cl = foodweb_layout(N, steps=5);
      @test_nowarn graph_network_plot(cl...);
    end
  end

end
