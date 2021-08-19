module TestCascade
using Test
using EcologicalNetworks
using EcologicalNetworks: Cascade

@test typeof(rand(Cascade(10, 0.1))) <: UnipartiteNetwork

@test richness(rand(Cascade(10, 0.1))) == 10
@test richness(rand(Cascade(10, 0.2))) == 10
@test richness(rand(Cascade(20, 0.1))) == 20

@test richness(rand(Cascade(10, 0.1))) == 10
@test richness(rand(Cascade(10, 10))) == 10

@test_throws ArgumentError rand(Cascade(10, 0.9))
@test_throws ArgumentError rand(Cascade(10, 0.7))
@test_throws ArgumentError rand(Cascade(-10, 0.1))

empirical_foodweb = EcologicalNetworks.nz_stream_foodweb()[1]
@test typeof(rand(Cascade(empirical_foodweb))) <: UnipartiteNetwork

end
