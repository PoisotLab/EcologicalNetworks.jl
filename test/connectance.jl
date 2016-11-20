module TestConnectance
    using Base.Test
    using EcologicalNetwork

    # Generate some data
    N = BipartiteProbaNetwork([0.0 0.1 0.0; 0.2 0.0 0.2; 0.4 0.5 0.0])

    @test_approx_eq links(N) 1.4
    @test_approx_eq links_var(N) 0.9
    @test_approx_eq connectance(N) 1.4 / 9.0
    @test_approx_eq connectance_var(N) 0.011111111111111111111

    # Once more with a deterministic network
    N = BipartiteNetwork([false true false; false false true; true true true])

    @test_approx_eq links(N) 5
    @test_approx_eq connectance(N) 5/9
    @test_approx_eq linkage_density(N) 5/6

    # Once more with a deterministic unipartite network
    N = UnipartiteNetwork([false true false; false false true; true true true])

    @test_approx_eq links(N) 5
    @test_approx_eq connectance(N) 5/9
    @test_approx_eq linkage_density(N) 5/3

end
