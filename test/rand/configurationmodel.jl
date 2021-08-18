module TestConfigurationModel
using Test
using EcologicalNetworks
using Distributions: Poisson, Exponential, NegativeBinomial

@test typeof(rand(ConfigurationModel(50, [rand(Poisson(5)) for i = 1:50]))) <: UnipartiteNetwork
@test richness(rand(ConfigurationModel(50, [rand(Poisson(5)) for i = 1:50]))) == 50


# wrong number of species
degseq = [rand(Poisson(5)) for i = 1:30]
@test_throws ArgumentError rand(ConfigurationModel(50, degseq))


@test_throws ArgumentError rand(ConfigurationModel(0, degseq))
@test_throws ArgumentError rand(ConfigurationModel(-10, degseq))

end
