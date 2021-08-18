module TestNHModel
using Test
using EcologicalNetworks

@test typeof(rand(NestedHierarchyModel(10, 20))) <: UnipartiteNetwork

@test richness(rand(NestedHierarchyModel(10, 20))) == 10
@test richness(rand(NestedHierarchyModel(20, 20))) == 20


@test_throws ArgumentError rand(NestedHierarchyModel(10, 99))
@test_throws ArgumentError rand(NestedHierarchyModel(10, 51))
@test_throws ArgumentError rand(NestedHierarchyModel(10, 50))
@test_throws ArgumentError rand(NestedHierarchyModel(10, 200))
@test_throws ArgumentError rand(NestedHierarchyModel(10, 0))

empirical_foodweb = EcologicalNetworks.nz_stream_foodweb()[1]
@test typeof(rand(NestedHierarchyModel(empirical_foodweb))) <: UnipartiteNetwork

end
