module TestModularityLouvain
using Base.Test
using EcologicalNetwork


# Louvain modularity
A = [
  true true true false false false; true true true false false false;
  false false false true true true; false false false true true true
  ]
B = BipartiteNetwork(A)
m = louvain(B, collect(1:richness(B)))
@test m.Q ≈ 0.5
@test Qr(m) ≈ 1.0

# Brim
m = brim(mcmullen(), rand(1:10, richness(mcmullen())))
@test m.Q ≈ 0.5 atol = 0.2
@test Qr(m) ≈ 0.5 atol = 0.2
@test brim(m).Q ≈ m.Q atol = 0.1

# LP-Brim
m = lpbrim(mcmullen(), rand(1:10, richness(mcmullen())))
@test m.Q ≈ 0.5 atol = 0.2
@test Qr(m) ≈ 0.5 atol = 0.2
@test lpbrim(m).Q ≈ m.Q atol = 0.1

end
