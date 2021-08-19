module TestNHModel
using Test
using EcologicalNetworks
using EcologicalNetworks: NestedHierarchy

@test typeof(rand(NestedHierarchy(10, 20))) <: UnipartiteNetwork

@test richness(rand(NestedHierarchy(10, 20))) == 10
@test richness(rand(NestedHierarchy(20, 20))) == 20


@test_throws ArgumentError rand(NestedHierarchy(10, 99))
@test_throws ArgumentError rand(NestedHierarchy(10, 51))
@test_throws ArgumentError rand(NestedHierarchy(10, 50))
@test_throws ArgumentError rand(NestedHierarchy(10, 200))
@test_throws ArgumentError rand(NestedHierarchy(10, 0))

empirical_foodweb = EcologicalNetworks.nz_stream_foodweb()[1]
@test typeof(rand(NestedHierarchy(empirical_foodweb))) <: UnipartiteNetwork

end
