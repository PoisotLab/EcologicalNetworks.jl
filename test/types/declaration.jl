module TestTypes
using Test
using EcologicalNetwork

@test typeof(UnipartiteNetwork(rand(Bool, (5, 5)))) <: UnipartiteNetwork
@test typeof(UnipartiteNetwork(rand(Bool, (5, 5)))) <: AbstractUnipartiteNetwork
@test typeof(UnipartiteNetwork(rand(Bool, (5, 5)))) <: DeterministicNetwork
@test typeof(UnipartiteNetwork(rand(Bool, (2, 2)), ["a", "b"])) <: DeterministicNetwork

@test typeof(BipartiteNetwork(rand(Bool, (3, 5)))) <: BipartiteNetwork
@test typeof(BipartiteNetwork(rand(Bool, (2, 3)), [:a, :b], [:c, :d, :e])) <: BipartiteNetwork
@test typeof(BipartiteNetwork(rand(Bool, (3, 5)))) <: AbstractBipartiteNetwork
@test typeof(BipartiteNetwork(rand(Bool, (3, 5)))) <: DeterministicNetwork

@test typeof(BipartiteProbabilisticNetwork(rand(7, 3))) <: BipartiteProbabilisticNetwork
@test typeof(BipartiteProbabilisticNetwork(rand(3, 4))) <: AbstractBipartiteNetwork
@test typeof(BipartiteProbabilisticNetwork(rand(2, 3))) <: ProbabilisticNetwork
@test typeof(BipartiteProbabilisticNetwork(rand(2, 3), ["a", "b"], ["c", "d", "e"])) <: ProbabilisticNetwork

@test typeof(UnipartiteProbabilisticNetwork(rand(3, 3))) <: UnipartiteProbabilisticNetwork
@test typeof(UnipartiteProbabilisticNetwork(rand(3, 3))) <: AbstractUnipartiteNetwork
@test typeof(UnipartiteProbabilisticNetwork(rand(3, 3))) <: ProbabilisticNetwork
@test typeof(UnipartiteProbabilisticNetwork(rand(3, 3), ["a", "b", "c"])) <: ProbabilisticNetwork

@test typeof(UnipartiteQuantitativeNetwork(rand(Int64, (5, 5)))) <: UnipartiteQuantitativeNetwork
@test typeof(UnipartiteQuantitativeNetwork(rand(Float64, (5, 5)))) <: QuantitativeNetwork
@test typeof(UnipartiteQuantitativeNetwork(rand(Float64, (2, 2)), [:a, :b])) <: QuantitativeNetwork
@test typeof(UnipartiteQuantitativeNetwork(rand(Float64, (2, 2)), ["a", "b"])) <: QuantitativeNetwork

@test typeof(BipartiteQuantitativeNetwork(rand(Float64, (3, 5)))) <: BipartiteQuantitativeNetwork
@test typeof(BipartiteQuantitativeNetwork(rand(Float64, (5, 6)))) <: AbstractBipartiteNetwork
@test typeof(BipartiteQuantitativeNetwork(rand(Int64, (5, 2)))) <: QuantitativeNetwork
@test typeof(BipartiteQuantitativeNetwork(rand(Float64, (3, 2)), ["a", "b", "c"], ["A", "B"])) <: BipartiteQuantitativeNetwork

@test_throws ArgumentError UnipartiteNetwork(rand(Bool, (5, 3)))
@test_throws ArgumentError UnipartiteNetwork(rand(Bool, (5, 5)), ["a", "b", "c"])
@test_throws ArgumentError UnipartiteNetwork(rand(Bool, (2, 2)), ["a", "b", "c"])
@test_throws ArgumentError BipartiteNetwork(rand(Bool, (3, 2)), ["a", "b", "c"], ["c", "d", "e"])
@test_throws ArgumentError BipartiteNetwork(rand(Bool, (3, 2)), ["a", "b", "c"], ["c", "e"])
@test_throws MethodError BipartiteNetwork(rand(Bool, (3, 2)), ["a", "b", "c"], [:e, :f])

@test typeof(UnipartiteProbabilisticNetwork(rand(3, 3), [:a, :b, :c])) <: UnipartiteProbabilisticNetwork
@test_throws ArgumentError UnipartiteProbabilisticNetwork(rand(3, 3).*2.0, [:a, :b, :c])

end
