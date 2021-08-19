module TestConfiguration
using Test
using EcologicalNetworks
using EcologicalNetworks: Configuration
using Distributions: Poisson, Exponential, NegativeBinomial

@test typeof(rand(Configuration(50, [rand(Poisson(5)) for i = 1:50]))) <: UnipartiteNetwork
@test richness(rand(Configuration(50, [rand(Poisson(5)) for i = 1:50]))) == 50


# wrong number of species
degseq = [rand(Poisson(5)) for i = 1:30]
@test_throws ArgumentError rand(Configuration(50, degseq))


@test_throws ArgumentError rand(Configuration(0, degseq))
@test_throws ArgumentError rand(Configuration(-10, degseq))

end
