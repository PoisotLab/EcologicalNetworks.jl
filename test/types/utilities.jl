module TestTypeUtilities
using Base.Test
using EcologicalNetwork

B = BipartiteProbabilisticNetwork(rand(3, 5))
@test typeof(copy(B)) == typeof(B)
@test size(B) == (3,5)

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

A = BipartiteNetwork([false true; true false], [:a, :b], [:c, :d])
@test has_interaction(A, :a, :d)
@test !has_interaction(A, :a, :c)
@test has_interaction(A, :b, :c)
@test !has_interaction(A, :b, :d)

A = UnipartiteNetwork(eye(Bool, 5))
X = nodiagonal(A)
@test !has_interaction(X, 1, 1)
@test !has_interaction(X, 2, 2)
@test !has_interaction(X, 3, 3)

# Accessing an interaction
A = UnipartiteNetwork([true false; true true], [:a, :b])
@test A[:a, :a]
@test A[:b, :a]
@test A[:b, :b]

# Accessing a range of interactions
A = UnipartiteNetwork(eye(Bool, 4), [:a, :b, :c, :d])
B = A[[:a, :b]]
@test typeof(B) <: UnipartiteNetwork
@test richness(B) == 2

# Accessing a range of interactions (bipartite case)
A = BipartiteNetwork([true false true; false true true; true true true], [:A, :B, :C], [:a, :b, :c])

B1 = A[:, [:b, :c]]
@test typeof(B1) == typeof(A)
@test richness(B1) == 5

B2 = A[[:A, :B], :]
@test typeof(B2) == typeof(A)
@test richness(B2) == 5

B3 = A[[:A, :B], [:a, :c]]
@test typeof(B3) == typeof(A)
@test richness(B3) == 4

S1 = A[:A, :]
@test typeof(S1) <: Set
@test eltype(S1) <: Symbol

S2 = A[:, :a]
@test typeof(S2) <: Set
@test eltype(S2) <: Symbol

end
