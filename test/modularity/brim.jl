module TestModularityBrim
using Base.Test
using EcologicalNetwork

    N = mccullen_1993()
    L = lp(N)[2]
    m = brim(N, L)

    @test Q(m...) ≈ 0.5 atol = 0.2
    @test Qr(m...) ≈ 0.5 atol = 0.2

end
