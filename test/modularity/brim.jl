module TestModularityBrim
using Test
using EcologicalNetworks
using LinearAlgebra

    N = web_of_life("M_PL_026")
    modules = lp(N)[2]
    m = brim(N, modules)

    @test Q(m...) ≈ 0.5 atol = 0.3
    @test Qr(m...) ≈ 0.5 atol = 0.3

    N = BipartiteProbabilisticNetwork(Matrix{Float64}(I, (50, 50)))
    modules = brim(lp(N)...)
    @test Q(modules...) > 0.95

    N = BipartiteNetwork(Matrix{Bool}(I, (50, 50)))
    modules = brim(lp(N)...)
    @test Q(modules...) > 0.95

end
