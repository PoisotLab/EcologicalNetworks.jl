module TestMotifs
    using Base.Test
    using EcologicalNetwork

@testset "Motif functions" begin

  @testset "Usual motifs" begin
    @test unipartitemotifs()[:S1].A = [0 1 0; 0 0 1; 0 0 0];
  end

    @testset "Single link, probabilistic" begin
        # Test with a single link
        N = UnipartiteProbaNetwork([0.2 0.8; 0.2 0.1])
        m = UnipartiteNetwork([false true; false false])
        pmotif = EcologicalNetwork.motif_internal(N, m)
        @test pmotif == vec([0.8 0.8 0.8 0.9])
    end

    @testset "Perfect match, probabilistic" begin
        # Test with a perfect match
        N = UnipartiteProbaNetwork([0.0 1.0; 0.0 0.0])
        m = UnipartiteNetwork([false true; false false])
        pmotif = EcologicalNetwork.motif_internal(N, m)
        @test pmotif == vec([1.0 1.0 1.0 1.0])
        @test motif_p(N, m) == 1.0
        @test motif_v(N, m) == 0.0
    end

    @testset "Fork food web" begin
        # Test with a fork-like thing
        diam = UnipartiteNetwork([0 1 0 0; 0 0 1 1; 0 0 0 0; 0 0 0 0])
        clin = UnipartiteNetwork([0 1 0; 0 0 1; 0 0 0])
        capp = UnipartiteNetwork([0 1 1; 0 0 0; 0 0 0])
        cdir = UnipartiteNetwork([0 0 1; 0 0 1; 0 0 0])

        @test motif(diam, clin) ≈ 2.0
        @test motif(diam, capp) ≈ 1.0
        @test motif(diam, cdir) ≈ 0.0
    end

    @testset "Diamond food web" begin
        # Test with a diamond food web
        diam = UnipartiteNetwork([0 1 1 0; 0 0 0 1; 0 0 0 1; 0 0 0 0])
        clin = UnipartiteNetwork([0 1 0; 0 0 1; 0 0 0])
        capp = UnipartiteNetwork([0 1 1; 0 0 0; 0 0 0])
        cdir = UnipartiteNetwork([0 0 1; 0 0 1; 0 0 0])

        @test motif(diam, clin) ≈ 2.0
        @test motif(diam, capp) ≈ 1.0
        @test motif(diam, cdir) ≈ 1.0
    end

    @testset "Linear food chain with a loop" begin
      lfc = UnipartiteNetwork([0 1 0; 0 0 1; 0 0 0])
      wsl = UnipartiteNetwork([1 1 0; 0 0 1; 0 0 0])

      @test motif(wsl, lfc) ≈ 1.0
    end

    @testset "Linear quantitative food chain with a loop" begin
      lfc = UnipartiteNetwork([0 1 0; 0 0 1; 0 0 0])
      wsl = UnipartiteQuantiNetwork([1 0.5 0; 0 0 1.6; 0 0 0])

      @test motif(wsl, lfc) ≈ 1.0
    end

    @testset "Bipartite test" begin
      # Test with a diamond food web
      diam = BipartiteNetwork([1 1 0; 1 1 1])
      tthr = BipartiteNetwork([1 0; 1 1])
      tfou = BipartiteNetwork([1 1; 1 1])

      @test motif(diam, tthr) ≈ 2.0
      @test motif(diam, tfou) ≈ 1.0
    end

    @testset "Three species" begin
      # Test on a three-species network
      B = UnipartiteNetwork([false true true; false false true; false false false])
      @test motif(B, B) == 1.0
    end

    BDN = BipartiteNetwork([false true true; false false true; false false false])
    @test motif(BDN, BDN) == 1.0

    # Test on the same network, this time with a proba one
    P = UnipartiteProbaNetwork([0.0 1.0 1.0; 0.0 0.0 1.0; 0.0 0.0 0.0])
    B = UnipartiteNetwork([false true true; false false true; false false false])
    @test motif_var(P, B) == 0.0

    # Test with some variation
    ovl = UnipartiteNetwork([false true true; false false true; false false false])
    N = UnipartiteProbaNetwork([0.0 1.0 0.8; 0.0 0.0 1.0; 0.0 0.0 0.0])
    @test motif(N, ovl) ≈ 0.8
    fchain = UnipartiteNetwork([false true false; false false true; false false false])
    @test motif(N, fchain) ≈ 0.2

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
      @test sum(all_probas) ≈ 1.0
    end

end
end
