include("./src/EcologicalNetwork.jl")
using EcologicalNetwork

D = UnipartiteNetwork(eye(Bool, 4))
degree(D)
K = simplify(D)
@test !isdegenerate(K)
@test typeof(D) == typeof(K)

N = BipartiteNetwork([false false false; true false true; true true false])
M = simplify(N)
@test isdegenerate(N)
@test !isdegenerate(M)

N = web_of_life("A_HP_002")

N = D

D = UnipartiteNetwork(eye(Bool, 4))
N = D
simplify(N)
