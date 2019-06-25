module TestResilience
    using Test, EcologicalNetworks

    A = rand([0, 1, 0.5], 10, 10)
    N = UnipartiteQuantitativeNetwork(A)

    @assert s(N) ≈ sum(A) / 10
    @assert s(N, dims=1) ≈ sum(A, dims=2)
    @assert s(N, dims=2) ≈ sum(A, dims=1)'

    @assert resilience(N) ≈ s(N) + symmetry(N) * heterogeneity(N)

    # species only interact with themselves
    Nid = UnipartiteNetwork([true false false false;
                              false true false false;
                              false false true false;
                              false false false true])

    @assert heterogeneity(Nid) ≈ 0.0
    # @assert symmetry(Nid)   NAN

    # symetric network
    Nsym = UnipartiteNetwork([false true true true;
                               true false false false;
                               true false false false;
                               true false false false])
    @assert symmetry(Nsym) ≈ 1.0  # in- and out degree is same
    @assert heterogeneity(Nsym) ≈ 0.5


    # asymetric network
    Nasym = UnipartiteNetwork([false true true true;
                               false false false false;
                               false false false false;
                               false false false false])
    @assert symmetry(Nasym) ≈ -1.0  # in- and out degree is same
    @assert heterogeneity(Nasym) ≈ 0.75

    v = ones(10) / 10
    Nhomo = UnipartiteProbabilisticNetwork(v * v')
    @assert isapprox(heterogeneity(Nhomo), 0.0, atol=1e-10)
end
