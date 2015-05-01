module TestMotifs
  using Base.Test
  using ProbabilisticNetwork

  # Test with a single link
  A = [0.2 0.8; 0.2 0.1]
  m = [0.0 1.0; 0.0 0.0]
  pmotif = ProbabilisticNetwork.motif_internal(A, m)
  @test pmotif == vec([0.8 0.8 0.8 0.9])

  # Test with a perfect match
  A = [0.0 1.0; 0.0 0.0]
  m = [0.0 1.0; 0.0 0.0]
  pmotif = ProbabilisticNetwork.motif_internal(A, m)
  @test pmotif == vec([1.0 1.0 1.0 1.0])
  @test motif_p(A, m) == 1.0
  @test motif_v(A, m) == 0.0

  # Test on a three-species network
  B = [0.0 1.0 1.0; 0.0 0.0 1.0; 0.0 0.0 0.0]
  @test motif(B, B) == 1.0
  @test motif_var(B, B) == 0.0

end
