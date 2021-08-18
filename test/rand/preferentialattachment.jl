module TestPreferentialAttachmentModel
using Test
using EcologicalNetworks
using Distributions: Categorical

@test typeof(rand(PreferentialAttachment(50, 0.3))) <: UnipartiteNetwork
@test richness(rand(PreferentialAttachment(30, 0.1))) == 30



@test typeof(rand(PreferentialAttachment(30, 0.1))) <: UnipartiteNetwork
@test richness(rand(PreferentialAttachment(50, 0.3))) == 50

@test typeof(rand(PreferentialAttachment((30, 30), 0.1))) <: UnipartiteNetwork
@test typeof(rand(PreferentialAttachment((30, 30), 0.1), BipartiteNetwork)) <:
      BipartiteNetwork

@test typeof(rand(PreferentialAttachment((30, 50), 0.1))) <: BipartiteNetwork

@test_throws ArgumentError rand(PreferentialAttachment(10, -0.1))
@test_throws ArgumentError rand(PreferentialAttachment(-10, 3))


end
