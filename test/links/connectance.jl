module TestConnectance
    using Test
    using EcologicalNetwork

    # Generate some data
    N = BipartiteProbabilisticNetwork([0.0 0.1 0.0; 0.2 0.0 0.2; 0.4 0.5 0.0])

    @test links(N) ≈ 1.4
    @test links_var(N) ≈ 0.9
    @test connectance(N) ≈ 1.4 / 9.0
    @test connectance_var(N) ≈ 0.011111111111111111111

    # Once more with a deterministic network
    N = BipartiteNetwork([false true false; false false true; true true true])

    @test links(N) ≈ 5
    @test connectance(N) ≈ 5/9
    @test linkage_density(N) ≈ 5/6

    # Once more with a deterministic unipartite network
    N = UnipartiteNetwork([false true false; false false true; true true true])

    @test links(N) ≈ 5
    @test connectance(N) ≈ 5/9
    @test linkage_density(N) ≈ 5/3

    # Links with quantitative networks
    K = BipartiteQuantitativeNetwork(rand(Float64, (3,3)))
    @test links(K) == 9

    # Convert to adjacency
    @test connectance(UnipartiteNetwork(eye(Bool, 10))) ≈ connectance(UnipartiteQuantitativeNetwork(eye(Int64, 10).*2))

end
