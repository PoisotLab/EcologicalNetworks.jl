module TestOTSIN
    using Test
    using EcologicalNetworks

    M = [1 2 1 1 1;
         0 5 0 0 0;
         3 1 1 0 0;
         1 1 1 2 1]
    
    a = [0.25, 0.25, 0.25, 0.25]
    b = [0.3, 0.1, 0.1, 0.25, 0.25]

    Q = optimaltransportation(M; a, b)
    @test Q isa AbstractMatrix
    @test sum(Q) ≈ 1.0
    @test sum(Q, dims=2)[:] ≈ a
    @test sum(Q, dims=1)[:] ≈ b
    @test optimaltransportation(M; a, b, λ=0.0) ≈ a * b'

    Q = optimaltransportation(M; a)
    @test sum(Q) ≈ 1.0
    @test sum(Q, dims=2)[:] ≈ a

    Q = optimaltransportation(M; b)
    @test sum(Q) ≈ 1.0
    @test sum(Q, dims=1)[:] ≈ b

    Q = optimaltransportation(M)
    @test sum(Q) ≈ 1.0

    N = BipartiteNetwork(M.>0)
    Q = optimaltransportation(N; a, b)

    @test Q isa BipartiteQuantitativeNetwork

end