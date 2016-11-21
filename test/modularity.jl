module TestModularity
    using Base.Test
    using EcologicalNetwork

    # Perfectly modular bipartite network
    A = [true true true false false false; true true true false false false;
         false false false true true true; false false false true true true]
    B = BipartiteNetwork(A)
    U = make_unipartite(B)
    mb = label_propagation(B, collect(1:richness(B)))
    mu = label_propagation(U, collect(1:richness(U)))

    @test mb.Q == 0.5
    @test length(unique(mb.L)) == 2
    @test mb.Q == mu.Q
    @test Qr(mb) == 1.0
    @test Qr(mb.N, ones(Int64, richness(mb.N))) == 0.0

    # Test the partition with only a network given
    @test Partition(B).Q == 0.0

    # Test Q from a partition
    @test Q(mb) == mb.Q

    # Test that the modularity if there is a single module
    @test Q(U, ones(Int64, richness(U))) == 0.0

    # Test with a probabilistic network
    P = map(Float64, A)
    pB = BipartiteProbaNetwork(P)
    pU = make_unipartite(pB)

    mb = label_propagation(pB, collect(1:richness(pB)))
    mu = label_propagation(pU, collect(1:richness(pU)))

    @test mb.Q > 0.25
    @test mu.Q > 0.25


end
