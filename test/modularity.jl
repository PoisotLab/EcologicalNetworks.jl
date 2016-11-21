module TestModularity
    using Base.Test
    using EcologicalNetwork


    # Perfectly modular bipartite network
    A = [true true true false false false; true true true false false false;
         false false false true true true; false false false true true true]
    B = BipartiteNetwork(A)
    U = make_unipartite(A)
    L = collect(1:richness(B))
    mb = label_propagation(B, L)
    mu = label_propagation(U, L)

    @test mb.Q == mu.Q
    @test Qr(mb) == 1.0

end
