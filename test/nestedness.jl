module TestNestedness
    using Base.Test
    using EcologicalNetwork

    # Generate some data

    A = BipartiteProbaNetwork([1.0 0.0 0.0; 0.0 0.1 0.0; 0.0 0.0 0.1])
    B = BipartiteProbaNetwork([1.0 1.0 1.0; 1.0 0.1 0.0; 1.0 0.0 0.0])
    C = BipartiteProbaNetwork([1.0 1.0 1.0; 1.0 0.1 0.3; 0.4 0.2 0.0])
    D = BipartiteProbaNetwork([1.0 1.0 1.0; 0.0 0.1 1.0; 0.0 0.0 1.0])

    @test η(A)[1] ≈ 0.0
    @test η(B)[1] ≈ 1.0
    @test η(C)[1] ≈ 0.9153846153846155
    @test η(D)[1] ≈ 1.0

    # Almeida-Neto original example
    AN = BipartiteNetwork([1 0 1 1 1; 1 1 1 0 0; 0 1 1 1 0; 1 1 0 0 0; 1 1 0 0 0])
    @test_approx_eq_eps nodf(AN)[1] 0.58 0.01
    @test_approx_eq_eps nodf(AN)[2] 0.63 0.01
    @test_approx_eq_eps nodf(AN)[3] 0.53 0.01

    # Some WNODF examples
    WN1A = BipartiteQuantiNetwork([5 4 3 2 1; 4 3 2 1 0; 3 2 1 0 0; 2 1 0 0 0; 1 0 0 0 0])
    WN1B = BipartiteQuantiNetwork([5 4 3 2 1; 5 4 3 2 0; 5 4 3 0 0; 5 4 0 0 0; 5 0 0 0 0])
    WN1D = BipartiteQuantiNetwork([5 1 1 1 1; 1 0 0 0 0; 1 0 0 0 0; 1 0 0 0 0; 1 0 0 0 0])

    @test_approx_eq_eps nodf(WN1A)[1] 1.0 0.01
    @test_approx_eq_eps nodf(WN1A)[2] 1.0 0.01
    @test_approx_eq_eps nodf(WN1A)[3] 1.0 0.01

    @test_approx_eq_eps nodf(WN1B)[1] 0.5 0.01
    @test_approx_eq_eps nodf(WN1B)[2] 1.0 0.01
    @test_approx_eq_eps nodf(WN1B)[3] 0.0 0.01

    @test_approx_eq_eps nodf(WN1D)[1] 0.4 0.01
    @test_approx_eq_eps nodf(WN1D)[2] 0.4 0.01
    @test_approx_eq_eps nodf(WN1D)[3] 0.4 0.01



end
