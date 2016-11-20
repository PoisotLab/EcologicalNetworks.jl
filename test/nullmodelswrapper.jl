module TestNullModelsWrapper
    using Base.Test
    using EcologicalNetwork

    # Test 1 -- model with one free species = no output
    A = map(Bool, [0.0 0.0 0.0; 0.0 1.0 0.0; 0.0 0.0 1.0])
    N = UnipartiteNetwork(A)
    B = nullmodel(N, n=10, max=10)
    @test length(B) == 0

    # Test 2 -- full graph converges
    A = map(Bool, [1.0 1.0; 1.0 1.0])
    N = UnipartiteNetwork(A)
    B = nullmodel(N, n=10, max=10)
    @test length(B) == 10

    # Test 3 -- works if max < n
    A = map(Bool, [1.0 1.0; 1.0 1.0])
    N = UnipartiteNetwork(A)
    B = nullmodel(N, n=5, max=2)
    @test length(B) == 5

end
