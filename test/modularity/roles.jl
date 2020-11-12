module TestModularityRoles
using Test
using EcologicalNetworks

    # Functional roles

    A = [
        false true false false false false;
        false false false true false false;
        false true false false false false;
        false false false false true false;
        false false false false false true;
        false false false false false false
        ]
    U = UnipartiteNetwork(A)
    L = Dict("s1"=>1, "s2"=>1, "s3"=>1, "s4"=>2, "s5"=>2, "s6"=>2)
    n = functional_cartography(U, L)

    # Values of z
    @test n["s1"][1] ≈ -0.57 atol = 0.02
    @test n["s2"][1] ≈  1.15 atol = 0.02
    @test n["s3"][1] ≈ -0.57 atol = 0.02
    @test n["s4"][1] ≈ -0.57 atol = 0.02
    @test n["s5"][1] ≈  1.15 atol = 0.02
    @test n["s6"][1] ≈ -0.57 atol = 0.02

    # Values of c
    @test n["s1"][2] ≈ 0.00 atol = 0.02
    @test n["s2"][2] ≈ 0.45 atol = 0.02
    @test n["s3"][2] ≈ 0.00 atol = 0.02
    @test n["s4"][2] ≈ 0.50 atol = 0.02
    @test n["s5"][2] ≈ 0.00 atol = 0.02
    @test n["s6"][2] ≈ 0.00 atol = 0.02

end