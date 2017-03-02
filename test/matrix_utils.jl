module TestMatrixUtilities
  using Base.Test
  using EcologicalNetwork

  # Function to make thresholded and binary networks
  N = UnipartiteProbaNetwork([0.2 0.05; 1.0 0.0])

  bin = make_binary(N)
  @test bin[1, 1] == true
  @test bin[2, 2] == false
  @test typeof(bin) == UnipartiteNetwork

  thr = make_threshold(N, 0.1)
  @test thr[1, 1] == true
  @test thr[1, 2] == false

  @test_throws DomainError make_threshold(N, 1.0)

  # Remove the diagonal
  N = UnipartiteProbaNetwork([1.0 1.0 1.0; 0.0 0.0 0.0; 1.0 1.0 1.0])
  @test nodiag(N)[2,2] == 0.0
  @test nodiag(N)[3,3] == 0.0
  @test nodiag(N)[1,1] == 0.0

  # Removing the diagonal does nothing on bipartite networks
  N = BipartiteProbaNetwork([1.0 1.0 1.0; 0.0 0.0 0.0; 1.0 1.0 1.0])
  @test N.A == nodiag(N).A
end
