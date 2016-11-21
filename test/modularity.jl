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

end
