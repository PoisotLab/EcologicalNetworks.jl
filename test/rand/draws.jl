module TestRandomDraws
using Base.Test
using EcologicalNetwork

B = UnipartiteProbabilisticNetwork(eye(Float64, 10))
C = rand(B)
@test typeof(C) <:UnipartiteNetwork
@test C[1,1]
@test !C[1,2]

B = BipartiteProbabilisticNetwork(eye(Float64, 10))
C = rand(B)
@test typeof(C) <:BipartiteNetwork
@test C[1,1]
@test !C[1,2]

B = BipartiteProbabilisticNetwork(eye(Float64, 10))
C = rand(B,10)
@test length(C) == 10
@test eltype(C) <: BipartiteNetwork

end
