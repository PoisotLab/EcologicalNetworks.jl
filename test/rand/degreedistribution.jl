module TestDegreeDistribution
using Test
using EcologicalNetworks
using EcologicalNetworks: DegreeDistribution
using Distributions: Poisson, Exponential, NegativeBinomial

@test typeof(rand(DegreeDistribution(50, Poisson(5)))) <: UnipartiteNetwork
@test richness(rand(DegreeDistribution(50, Poisson(5)))) == 50


@test_throws ArgumentError rand(DegreeDistribution(0, Poisson(5)))
@test_throws ArgumentError rand(DegreeDistribution(-1, Poisson(5)))


@test_throws ArgumentError rand(DegreeDistribution(50, Exponential(1)))

end
