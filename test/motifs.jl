module TestMotifs
  using Base.Test
  using EcologicalNetwork

  # Test with a single link
  N = UnipartiteProbaNetwork([0.2 0.8; 0.2 0.1])
  m = UnipartiteNetwork([false true; false false])
  pmotif = EcologicalNetwork.motif_internal(N, m)
  @test pmotif == vec([0.8 0.8 0.8 0.9])

  # Test with a perfect match
  N = UnipartiteProbaNetwork([0.0 1.0; 0.0 0.0])
  m = UnipartiteNetwork([false true; false false])
  pmotif = EcologicalNetwork.motif_internal(N, m)
  @test pmotif == vec([1.0 1.0 1.0 1.0])
  @test motif_p(N, m) == 1.0
  @test motif_v(N, m) == 0.0

  # Test on a three-species network
  B = UnipartiteNetwork([false true true; false false true; false false false])
  @test motif(B, B) == 1.0
  
  BDN = BipartiteNetwork([false true true; false false true; false false false])
  @test motif(BDN, BDN) == 1.0

  # Test on the same network, this time with a proba one
  P = UnipartiteProbaNetwork([0.0 1.0 1.0; 0.0 0.0 1.0; 0.0 0.0 0.0])
  @test motif_var(P, B) == 0.0

  # Test with some variation
  ovl = UnipartiteNetwork([false true true; false false true; false false false])
  N = UnipartiteProbaNetwork([0.0 1.0 0.8; 0.0 0.0 1.0; 0.0 0.0 0.0])
  @test_approx_eq motif(N, ovl) 0.8
  fchain = UnipartiteNetwork([false true false; false false true; false false false])
  @test_approx_eq motif(N, fchain) 0.2

  # Test of the simplest situation: two nodes, ten random matrices
  for i in 1:10
    N = BipartiteProbaNetwork(rand((2, 2)))
    possible_motifs = (
        [0 1; 0 0], [1 0; 0 0], [0 0; 1 0], [0 0; 0 1],
        [1 1; 0 0], [1 0; 0 1], [1 0; 1 0],
        [0 1; 1 0], [0 1; 0 1],
        [0 0; 1 1],
        [0 1; 1 1], [1 0; 1 1], [1 1; 1 0], [1 1; 0 1],
        [0 0; 0 0], [1 1; 1 1]
    )
    all_probas = map((x) -> motif_p(N, BipartiteNetwork(map(Bool, x))), possible_motifs)
    @test_approx_eq sum(all_probas) 1.0
  end

end
