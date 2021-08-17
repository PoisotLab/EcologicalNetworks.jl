module TestPreferentialAttachmentModel
  using Test
  using EcologicalNetworks
  using Distributions: Categorical

  @test typeof(rand(PreferentialAttachment(50, 0.3))) <: UnipartiteNetwork
  @test richness(rand(PreferentialAttachment(30, 0.1))) == 30

end


