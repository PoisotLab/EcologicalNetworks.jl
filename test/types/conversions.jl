module TestTypesConversions
using Test
using EcologicalNetworks

N = BipartiteNetwork([true false; true true], [:a, :b], [:A, :B])
@test_throws AssertionError has_interaction(N, :A, :B)
M = convert(UnipartiteNetwork, N)
@test has_interaction(M, :a, :A)
@test !has_interaction(M, :a, :B)
@test has_interaction(M, :b, :A)
@test has_interaction(M, :b, :B)
@test !has_interaction(M, :A, :B)

# Convert back to bipartite
K = convert(BipartiteNetwork, M)
@test has_interaction(M, :b, :B)
@test !has_interaction(M, :A, :B)

N = BipartiteQuantitativeNetwork([4 0 ; 2 1], [:a, :b], [:A, :B])
M = convert(UnipartiteQuantitativeNetwork, N)
@test has_interaction(M, :a, :A)
@test !has_interaction(M, :a, :B)
@test has_interaction(M, :b, :A)
@test has_interaction(M, :b, :B)
@test !has_interaction(M, :A, :B)

N = BipartiteProbabilisticNetwork([0.3 0 ; 0.1 0.9], [:a, :b], [:A, :B])
M = convert(UnipartiteProbabilisticNetwork, N)
@test has_interaction(M, :a, :A)
@test !has_interaction(M, :a, :B)
@test has_interaction(M, :b, :A)
@test has_interaction(M, :b, :B)
@test !has_interaction(M, :A, :B)
L = convert(AbstractUnipartiteNetwork, N)
@test has_interaction(L, :a, :A)
@test typeof(L) <: AbstractUnipartiteNetwork
@test typeof(L) <: UnipartiteProbabilisticNetwork

N = BipartiteQuantitativeNetwork([4 0 ; 2 1], [:a, :b], [:A, :B])
M = convert(BipartiteNetwork, N)
@test has_interaction(M, :a, :A)
@test !has_interaction(M, :a, :B)
@test has_interaction(M, :b, :A)
@test has_interaction(M, :b, :B)
L = convert(BinaryNetwork, N)
@test has_interaction(L, :a, :A)
@test typeof(L) <: BipartiteNetwork

N = UnipartiteQuantitativeNetwork([4 0 ; 2 1], [:a, :b])
M = convert(UnipartiteNetwork, N)
@test has_interaction(M, :a, :a)
@test !has_interaction(M, :a, :b)
@test has_interaction(M, :b, :a)
@test has_interaction(M, :b, :b)

N = BipartiteProbabilisticNetwork([1.0 1.0; 1.0 1.0])
M = convert(UnipartiteProbabilisticNetwork, N)
@test typeof(M) <: UnipartiteProbabilisticNetwork
@test M[3,1] == 0.0
@test M[1,4] == 1.0

N = BipartiteNetwork([true true; true true])
M = convert(UnipartiteNetwork, N)
@test typeof(M) <: UnipartiteNetwork

N = BipartiteProbabilisticNetwork([0.2 0.4; 0.4 0.2])
@test typeof(N<0.2) <: BipartiteNetwork
@test links(N<0.2) == 0
@test typeof(N<=0.2) <: BipartiteNetwork
@test links(N<=0.2) == 2
@test typeof(N>0.4) <: BipartiteNetwork
@test links(N>0.4) == 0
@test typeof(N>=0.4) <: BipartiteNetwork
@test links(N>=0.4) == 2

N = BipartiteQuantitativeNetwork([0.2 0.4; 0.4 0.2])
@test typeof(N<0.2) <: BipartiteNetwork
@test links(N<0.2) == 0
@test typeof(N<=0.2) <: BipartiteNetwork
@test links(N<=0.2) == 2
@test typeof(N>0.4) <: BipartiteNetwork
@test links(N>0.4) == 0
@test typeof(N>=0.4) <: BipartiteNetwork
@test links(N>=0.4) == 2

N = UnipartiteProbabilisticNetwork([0.2 0.4; 0.4 0.2])
@test typeof(N<0.2) <: UnipartiteNetwork
@test links(N<0.2) == 0
@test typeof(N<=0.2) <: UnipartiteNetwork
@test links(N<=0.2) == 2
@test typeof(N>0.4) <: UnipartiteNetwork
@test links(N>0.4) == 0
@test typeof(N>=0.4) <: UnipartiteNetwork
@test links(N>=0.4) == 2

N = UnipartiteQuantitativeNetwork([0.2 0.4; 0.4 0.2])
@test typeof(N<0.2) <: UnipartiteNetwork
@test links(N<0.2) == 0
@test typeof(N<=0.2) <: UnipartiteNetwork
@test links(N<=0.2) == 2
@test typeof(N>0.4) <: UnipartiteNetwork
@test links(N>0.4) == 0
@test typeof(N>=0.4) <: UnipartiteNetwork
@test links(N>=0.4) == 2

end
