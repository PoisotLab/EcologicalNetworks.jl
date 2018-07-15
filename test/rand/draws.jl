module TestRandomDraws
using Test
using EcologicalNetwork

B = UnipartiteProbabilisticNetwork(Matrix{Float64}(I, (10,10)))
C = rand(B)
@test typeof(C) <:UnipartiteNetwork
@test C[1,1]
@test !C[1,2]

B = BipartiteProbabilisticNetwork(Matrix{Float64}(I, (10,10)))
C = rand(B)
@test typeof(C) <:BipartiteNetwork
@test C[1,1]
@test !C[1,2]

B = BipartiteProbabilisticNetwork(Matrix{Float64}(I, (10,10)))
C = rand(B, 10)
@test length(C) == 10
@test eltype(C) <: BipartiteNetwork

end
