module TestNiche
using Test
using EcologicalNetworks
using EcologicalNetworks: Niche

@test typeof(rand(Niche(10, 20))) <: UnipartiteNetwork

@test richness(rand(Niche(10, 20))) == 10
@test richness(rand(Niche(10, 49))) == 10
@test richness(rand(Niche(20, 20))) == 20

@test_throws ArgumentError rand(Niche(10, 99))
@test_throws ArgumentError rand(Niche(10, 51))
@test_throws ArgumentError rand(Niche(10, 50))
@test_throws ArgumentError rand(Niche(10, 200))
@test_throws ArgumentError rand(Niche(10, 0))

empirical_foodweb = EcologicalNetworks.nz_stream_foodweb()[1]
@test typeof(rand(Niche(empirical_foodweb))) <: UnipartiteNetwork

end
