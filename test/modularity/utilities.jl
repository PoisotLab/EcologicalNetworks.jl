module TestModularityUtilities
using Base.Test
using EcologicalNetwork

# Perfectly modular bipartite network
A = [
  true true true false false false; true true true false false false;
  false false false true true true; false false false true true true
  ]
B = BipartiteNetwork(A)
U = convert(UnipartiteNetwork, B)

LB = Dict(zip(species(B), [1,1,2,2,1,1,1,2,2,2]))
LU = Dict(zip(species(U), [1,1,2,2,1,1,1,2,2,2]))

@test Q(B, LB) == 0.5
@test Q(U, LU) == 0.5
@test Qr(B, LB) == 1.0
@test Qr(U, LU) == 1.0

end
