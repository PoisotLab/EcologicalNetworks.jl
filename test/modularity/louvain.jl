module TestModularityLouvain
using Test
using EcologicalNetworks


# Louvain modularity
A = [
  true true true false false false; true true true false false false;
  false false false true true true; false false false true true true
  ]
B = BipartiteNetwork(A)
m = louvain(B, collect(1:richness(B)))
@test m.Q ≈ 0.5
@test Qr(m) ≈ 1.0

end
