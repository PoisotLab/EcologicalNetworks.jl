module TestModularityLabelPropagation
using Test
using EcologicalNetwork

A = [
  true true true false false false; true true true false false false;
  false false false true true true; false false false true true true
  ]
B = BipartiteNetwork(A)
U = convert(AbstractUnipartiteNetwork, B)
mb = lp(B)
mu = lp(U)

@test Q(mb...) == 0.5
@test Q(mu...) == 0.5
@test Qr(mb...) == 1.0
@test Qr(mu...) == 1.0

@test length(unique(collect(values(mb[2])))) == 2
@test length(unique(collect(values(mu[2])))) == 2

end
