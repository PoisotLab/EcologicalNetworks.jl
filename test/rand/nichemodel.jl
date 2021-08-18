module TestNicheModel
using Test
using EcologicalNetworks

@test typeof(rand(NicheModel(10, 20))) <: UnipartiteNetwork

@test richness(rand(NicheModel(10, 20))) == 10
@test richness(rand(NicheModel(10, 49))) == 10
@test richness(rand(NicheModel(20, 20))) == 20

@test_throws ArgumentError rand(NicheModel(10, 99))
@test_throws ArgumentError rand(NicheModel(10, 51))
@test_throws ArgumentError rand(NicheModel(10, 50))
@test_throws ArgumentError rand(NicheModel(10, 200))
@test_throws ArgumentError rand(NicheModel(10, 0))

empirical_foodweb = EcologicalNetworks.nz_stream_foodweb()[1]
@test typeof(rand(NicheModel(empirical_foodweb))) <: UnipartiteNetwork

end
