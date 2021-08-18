module TestRandomDraws
using Test
using EcologicalNetworks
using LinearAlgebra

B = UnipartiteProbabilisticNetwork(Matrix{Float64}(I, (10, 10)))
C = rand(B)
@test typeof(C) <: UnipartiteNetwork
@test C[1, 1]
@test !C[1, 2]

B = BipartiteProbabilisticNetwork(Matrix{Float64}(I, (10, 10)))
C = rand(B)
@test typeof(C) <: BipartiteNetwork
@test C[1, 1]
@test !C[1, 2]

B = BipartiteProbabilisticNetwork(Matrix{Float64}(I, (10, 10)))
C = rand(B, 10)
@test length(C) == 10
@test eltype(C) <: BipartiteNetwork

B = BipartiteProbabilisticNetwork(Matrix{Float64}(I, (10, 10)))
D = rand(B, (3, 3))
@test size(D) == (3, 3)
@test eltype(D) <: BipartiteNetwork

end
