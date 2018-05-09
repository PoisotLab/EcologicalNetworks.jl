module TestModularityBrim
using Base.Test
using EcologicalNetwork

    N = web_of_life("M_PL_026")
    modules = lp(N)[2]
    m = brim(N, modules)

    @test Q(m...) ≈ 0.5 atol = 0.2
    @test Qr(m...) ≈ 0.5 atol = 0.2

end
