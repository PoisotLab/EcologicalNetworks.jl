module TestModularityBrim
using Base.Test
using EcologicalNetwork

    N = web_of_life("M_PL_026")
    modules = lp(N)[2]
    m = brim(N, modules)

    @test Q(m...) ≈ 0.5 atol = 0.3
    @test Qr(m...) ≈ 0.5 atol = 0.3

    N = BipartiteProbabilisticNetwork(eye(Float64, 50))
    modules = brim(lp(N)...)
    @test Q(modules...) ≈ 0.5

    N = BipartiteNetwork(eye(Bool, 50))
    modules = brim(lp(N)...)
    @test Q(modules...) ≈ 0.5

end
