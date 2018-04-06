module TestTypeUtilities
using Base.Test
using EcologicalNetwork

B = BipartiteProbabilisticNetwork(rand(3, 5))
@test typeof(copy(B)) == typeof(B)

B = BipartiteProbabilisticNetwork(rand(3, 5))
X = copy(B)
B[1, 2] = 0.0654321
X[1, 2] = 0.0123456
@test B[1, 2] != X[1, 2]

A = BipartiteNetwork([false true; false false])
@test typeof(A) <: DeterministicNetwork

A = UnipartiteNetwork([false true; false false])
@test typeof(A) <: DeterministicNetwork

# Is there an interaction?
A = UnipartiteNetwork([false true; true false])
@test has_interaction(A, 1, 2)
@test !has_interaction(A, 1, 1)

A = UnipartiteQuantitativeNetwork([0.0 1.0; 1.0 0.0])
@test has_interaction(A, 1, 2)
@test !has_interaction(A, 1, 1)

A = UnipartiteNetwork([false true; true false], [:a, :b])
@test has_interaction(A, :a, :b)
@test has_interaction(A, :b, :a)
@test !has_interaction(A, :b, :b)
@test !has_interaction(A, :a, :a)

end
