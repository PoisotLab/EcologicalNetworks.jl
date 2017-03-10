module TestTypes
  using Base.Test
  using EcologicalNetwork

  @test typeof(BipartiteProbaNetwork(rand(3, 3))) == BipartiteProbaNetwork
  @test typeof(BipartiteProbaNetwork(rand(3, 3))) <: Bipartite
  @test typeof(BipartiteProbaNetwork(rand(3, 3))) <: ProbabilisticNetwork

  @test typeof(UnipartiteProbaNetwork(rand(3, 3))) == UnipartiteProbaNetwork
  @test typeof(UnipartiteProbaNetwork(rand(3, 3))) <: Unipartite
  @test typeof(UnipartiteProbaNetwork(rand(3, 3))) <: ProbabilisticNetwork

  @test typeof(BipartiteNetwork(rand(Bool, (3, 3)))) == BipartiteNetwork
  @test typeof(BipartiteNetwork(rand(Bool, (3, 3)))) <: Bipartite
  @test typeof(BipartiteNetwork(rand(Bool, (3, 3)))) <: DeterministicNetwork

  @test typeof(UnipartiteNetwork(rand(Bool, (3, 3)))) == UnipartiteNetwork
  @test typeof(UnipartiteNetwork(rand(Bool, (3, 3)))) <: Unipartite
  @test typeof(UnipartiteNetwork(rand(Bool, (3, 3)))) <: DeterministicNetwork

  @test typeof(UnipartiteQuantiNetwork(rand(Int64, (5, 5)))) == UnipartiteQuantiNetwork
  @test typeof(UnipartiteQuantiNetwork(rand(Float64, (5, 5)))) <: QuantitativeNetwork

  @test typeof(BipartiteQuantiNetwork(rand(Float64, (5, 5)))) == BipartiteQuantiNetwork
  @test typeof(BipartiteQuantiNetwork(rand(Float64, (5, 5)))) <: Bipartite
  @test typeof(BipartiteQuantiNetwork(rand(Int64, (5, 5)))) <: QuantitativeNetwork

  B = BipartiteProbaNetwork(rand(3, 5))
  @test typeof(copy(B)) == typeof(B)

  B = BipartiteProbaNetwork(rand(3, 5))
  X = copy(B)
  B[1, 2] = 0.0654321
  X[1, 2] = 0.0123456
  @test B[1, 2] != X[1, 2]


  A = BipartiteNetwork([0 1; 0 0])
  @test typeof(A) <: DeterministicNetwork

  A = UnipartiteNetwork([0 1; 0 0])
  @test typeof(A) <: DeterministicNetwork

end
