module TestModularity
  using Base.Test
  using ProbabilisticNetwork

  # Example network
  A = [1.0 1.0 1.0 0.0 0.0 0.0;
  1.0 1.0 1.0 0.0 0.0 0.0;
  1.0 1.0 1.0 0.0 0.0 0.0;
  0.0 0.0 0.0 1.0 1.0 1.0;
  0.0 0.0 0.0 1.0 1.0 1.0;
  0.0 0.0 0.0 1.0 1.0 1.0;]
  A = make_unipartite(A)

  println(modularity(A))

end
