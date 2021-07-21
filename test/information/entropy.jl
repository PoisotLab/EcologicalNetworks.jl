module TestEntropy
    using Test
    using EcologicalNetworks

    # DIRAC NETWORK
    # only a single interaction

    Ndirac = UnipartiteProbabilisticNetwork([0 0 1; 0 0 0; 0 0 0] / 2)

    inf_decomp_dirac = information_decomposition(Ndirac, norm=true)

    @test inf_decomp_dirac[:D] ≈ 1.0
    @test inf_decomp_dirac[:I] ≈ 0.0
    @test inf_decomp_dirac[:V] ≈ 0.0

    # IDENTITY NETWORK
    # one partner per species, only mutual information is different from 0

    Nid = BipartiteQuantitativeNetwork([1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1])

    inf_decomp_id = information_decomposition(Nid)

    @test inf_decomp_id[:D] ≈ 0.0
    @test inf_decomp_id[:I] ≈ 2.0log2(4.0)
    @test inf_decomp_id[:V] ≈ 0.0

    # UNIFORM NETWORK
    # every species interacts with every other species

    Nunif = BipartiteNetwork(ones(Bool, 10, 6))

    inf_decomp_unif = information_decomposition(Nunif)

    @test convert2effective(inf_decomp_unif[:D]) ≈ 1.0
    @test convert2effective(inf_decomp_unif[:I]) ≈ 1.0
    @test convert2effective(inf_decomp_unif[:V]) ≈ 10 * 6


    # network with assymetric information
    # information is only determined by columns

    Nassym = BipartiteQuantitativeNetwork(ones(5, 1) * rand(1, 7))

    @test mutual_information(Nassym) < 1e-10  # no information between the two variables
    @test diff_entropy_uniform(Nassym; dims=1) < 1e-10
    @test diff_entropy_uniform(Nassym; dims=2) > 0.0
    @test conditional_entropy(Nassym, 2) ≈ entropy(Nassym, dims=1)
end
