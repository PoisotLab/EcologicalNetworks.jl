module TestModularityBrim
using Test
using EcologicalNetwork

    N = web_of_life("M_PL_026")
    L = lp(N)[2]
    m = brim(N, L)

    @test Q(m...) ≈ 0.5 atol = 0.2
    @test Qr(m...) ≈ 0.5 atol = 0.2

end
