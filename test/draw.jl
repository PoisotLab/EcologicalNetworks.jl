module TestPlot
using Base.Test
using EcologicalNetwork
using Plots

n = BipartiteNetwork(rand(Bool, (10, 10)))
p = label_propagation(n, collect(1:20))

plot(n)
plot(n, p)

end
