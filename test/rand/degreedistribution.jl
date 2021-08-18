module TestDegreeDistributionModel
using Test
using EcologicalNetworks
using Distributions: Poisson, Exponential, NegativeBinomial

@test typeof(rand(DegreeDistributionModel(50, Poisson(5)))) <: UnipartiteNetwork
@test richness(rand(DegreeDistributionModel(50, Poisson(5)))) == 50


@test_throws ArgumentError rand(DegreeDistributionModel(0, Poisson(5)))
@test_throws ArgumentError rand(DegreeDistributionModel(-1, Poisson(5)))


@test_throws ArgumentError rand(DegreeDistributionModel(50, Exponential(1)))

end
