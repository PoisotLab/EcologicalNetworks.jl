module TestModularityLabelPropagation
using Test
using EcologicalNetworks

A = [
  true true true false false false; true true true false false false;
  false false false true true true; false false false true true true
  ]
B = BipartiteNetwork(A)
U = convert(AbstractUnipartiteNetwork, B)

@test maximum([Q(lp(B)...) for i in 1:10]) ≤ 0.5
@test maximum([Q(lp(U)...) for i in 1:10]) ≤ 0.5
@test maximum([Qr(lp(B)...) for i in 1:10]) ≤ 1.0
@test maximum([Qr(lp(U)...) for i in 1:10]) ≤ 1.0

n, m = salp(B; steps=500)
@test Q(n, m) > 0.0

end
