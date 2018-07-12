module TestModularityLabelPropagation
using Base.Test
using EcologicalNetwork

A = [
  true true true false false false; true true true false false false;
  false false false true true true; false false false true true true
  ]
B = BipartiteNetwork(A)
U = convert(AbstractUnipartiteNetwork, B)
mb = lp(B)
mu = lp(U)

@test maximum([Q(lp(B)...) for i in 1:10]) ≤ 0.5
@test maximum([Q(lp(U)...) for i in 1:10]) ≤ 0.5
@test maximum([Qr(lp(B)...) for i in 1:10]) ≤ 1.0
@test maximum([Qr(lp(U)...) for i in 1:10]) ≤ 1.0

@test length(unique(collect(values(mb[2])))) ∈ [2, 3]
@test length(unique(collect(values(mu[2])))) ∈ [2, 3]

end
