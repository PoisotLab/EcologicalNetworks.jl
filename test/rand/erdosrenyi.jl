module TestErdosRenyiModel
using Test
using EcologicalNetworks
using EcologicalNetworks: ErdosRenyi

@test typeof(rand(ErdosRenyi(30, 0.1))) <: UnipartiteNetwork
@test richness(rand(ErdosRenyi(50, 0.3))) == 50

@test typeof(rand(ErdosRenyi((30, 30), 0.1))) <: UnipartiteNetwork
@test typeof(rand(ErdosRenyi((30, 30), 0.1), BipartiteNetwork)) <: BipartiteNetwork

@test typeof(rand(ErdosRenyi((30, 50), 0.1))) <: BipartiteNetwork

@test_throws ArgumentError rand(ErdosRenyi(10, -0.1))
@test_throws ArgumentError rand(ErdosRenyi(-10, 3))

empirical_foodweb = EcologicalNetworks.nz_stream_foodweb()[1]
@test typeof(rand(ErdosRenyi(empirical_foodweb))) <: UnipartiteNetwork


end
