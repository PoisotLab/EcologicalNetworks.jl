module TestTypeUtilities
using Test
using EcologicalNetworks
using LinearAlgebra

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

A = UnipartiteNetwork(Matrix(I, (5,5)))
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
A = UnipartiteNetwork(Matrix(I, (4,4)), [:a, :b, :c, :d])
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

# Transposition
A = web_of_life("A_HP_001")
s1, s2 = size(A)
B = permutedims(A)
@test size(B) == (s2, s1)

# Get index

A = UnipartiteQuantitativeNetwork([1 2 3; 4 5 6; 7 8 9], [:a, :b, :c])
@test A[:a, :a] == 1
@test A[:a, :b] == 2
@test A[:a, :c] == 3
@test A[:b, :a] == 4
@test A[:b, :b] == 5
@test A[:b, :c] == 6
@test A[:c, :a] == 7
@test A[:c, :b] == 8
@test A[:c, :c] == 9

@test A[[:a, :b]][:a,:b] == 2
@test A[[:a, :b]][:a,:a] == 1
@test A[[:a, :b]][:b,:a] == 4
@test A[[:a, :b]][:b,:b] == 5

# Modify elements
N = UnipartiteNetwork(zeros(Bool, (4,4)))
@test links(N) == 0
N[1,1] = true
@test links(N) == 1
N["s2", "s4"] = true
@test links(N) == 2

N = BipartiteNetwork(zeros(Bool, (4,4)))
@test links(N) == 0
N[1,1] = true
@test links(N) == 1
N["t1", "b2"] = true
@test links(N) == 2
nodiagonal!(N)
@test links(N) == 2

# Interactions
interactions(BipartiteQuantitativeNetwork(rand(Float64, (3,5))))
interactions(BipartiteProbabilisticNetwork(rand(Float64, (3,5))))

# Test throws

@test_throws ArgumentError species(BipartiteQuantitativeNetwork(rand(Float64, (3,5))); dims=5)

# Iteration
for (i, int) in enumerate(unipartitemotifs().S1)
    if i == 1
        @test int.from == :a
        @test int.to == :b
    end
    if i == 2
        @test int.from == :b
        @test int.to == :c
    end
end

for (i, int) in enumerate(null2(unipartitemotifs().S1))
    if i == 1
        @test int.from == :a
        @test int.to == :a
        @test int.probability ≈ 1/6
    end
    if i == 2
        @test int.from == :b
        @test int.to == :a
        @test int.probability ≈ 1/3
    end
end

end
