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

@test Q(B, [1,1,2,2], [1,1,1,2,2,2]) == 0.5
@test Q(U, [1,1,2,2,1,1,1,2,2,2]) == 0.5
@test Qr(B, [1,1,2,2], [1,1,1,2,2,2]) == 1.0
@test Qr(U, [1,1,2,2,1,1,1,2,2,2]) == 1.0

end
