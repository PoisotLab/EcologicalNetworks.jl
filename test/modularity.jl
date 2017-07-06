module TestModularity
using Base.Test
using EcologicalNetwork

# Perfectly modular bipartite network
A = [
  true true true false false false; true true true false false false;
  false false false true true true; false false false true true true
  ]
B = BipartiteNetwork(A)
U = make_unipartite(B)
mb = label_propagation(B, collect(1:richness(B)))
mu = label_propagation(U, collect(1:richness(U)))

@test mb.Q == 0.5
@test length(unique(mb.L)) == 2
@test mb.Q == mu.Q
@test Qr(mb) == 1.0
@test Qr(mu) == 1.0
@test Qr(mb.N, ones(Int64, richness(mb.N))) == 0.0

# Test the partition with only a network given
@test Partition(B).Q == 0.0

# Test Q from a partition
@test Q(mb) == mb.Q

# Test that the modularity if there is a single module
@test Q(U, ones(Int64, richness(U))) == 0.0

# Test with a probabilistic network
P = map(Float64, A)
pB = BipartiteProbaNetwork(P)
pU = make_unipartite(pB)

# We know that the best modularity should be 0.5
mpu = label_propagation(pU, collect(1:richness(pU)))
ispointfive = mpu.Q == 0.5
while !ispointfive
  mpu = label_propagation(pU, collect(1:richness(pU)))
  ispointfive = mpu.Q == 0.5
end

mpb = label_propagation(pB, collect(1:richness(pB)))
ispointfive = mpb.Q == 0.5
while !ispointfive
  mpb = label_propagation(pB, collect(1:richness(pB)))
  ispointfive = mpb.Q == 0.5
end

@test mpu.Q ≈ mpb.Q
@test mpu.Q ≈ 0.5
@test mpb.Q ≈ 0.5

# Modularity wrapper
test_10 = modularity(pB, collect(1:richness(pB)), label_propagation, replicates=10)
@test length(test_10) == 10
@test best_partition(test_10)[1].Q ≈ 0.5

# Test with a quantitative network
Q1 = BipartiteQuantiNetwork(eye(Int64, 10))
Q2 = BipartiteQuantiNetwork(eye(Int64, 10).*10)
@test label_propagation(Q1, collect(1:20)).Q ≈ 0.9
@test label_propagation(Q2, collect(1:20)).Q ≈ 0.9
@test label_propagation(make_unipartite(Q2), collect(1:20)).Q ≈ 0.9

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
A = [
  true true true false false false; true true true false false false;
  false false false true true true; false false false true true true
  ]
B = BipartiteNetwork(A)
m = brim(B, rand(1:4, richness(B)))
@test m.Q ≈ 0.5
@test Qr(m) ≈ 1.0
end
