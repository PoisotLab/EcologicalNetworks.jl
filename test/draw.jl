module TestPlot
using Base.Test
using EcologicalNetwork
using Plots

n = BipartiteNetwork(rand(Bool, (10, 10)))
n1 = BipartiteNetwork(rand(Bool, (1, 19)))
n2 = BipartiteNetwork(rand(Bool, (19, 1)))
p = label_propagation(n, collect(1:20))

for t in [n1, n2, n]
  plot(t)
  plot(t, p)
end

end
