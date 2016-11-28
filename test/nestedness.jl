module TestNestedness
    using Base.Test
    using EcologicalNetwork

    # Generate some data

    A = BipartiteProbaNetwork([1.0 0.0 0.0; 0.0 0.1 0.0; 0.0 0.0 0.1])
    B = BipartiteProbaNetwork([1.0 1.0 1.0; 1.0 0.1 0.0; 1.0 0.0 0.0])
    C = BipartiteProbaNetwork([1.0 1.0 1.0; 1.0 0.1 0.3; 0.4 0.2 0.0])
    D = BipartiteProbaNetwork([1.0 1.0 1.0; 0.0 0.1 1.0; 0.0 0.0 1.0])

    @test_approx_eq η(A)[1] 0.0
    @test_approx_eq η(B)[1] 1.0
    @test_approx_eq η(C)[1] 0.9153846153846155
    @test_approx_eq η(D)[1] 1.0

    N = BipartiteNetwork([1 1 1 1; 1 1 1 0; 1 1 0 0; 1 0 0 0])

    @test_approx_eq nodf(N)[1] 1.0
    @test_approx_eq nodf(N)[2] 1.0
    @test_approx_eq nodf(N)[3] 1.0


end
