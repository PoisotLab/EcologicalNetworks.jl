include("./src/EcologicalNetwork.jl")
using EcologicalNetwork

A = [
  true true true false false false; true true true false false false;
  false false false true true true; false false false true true true
  ]

A = zeros(Bool, (12,12))
A[1:4,1:4] = rand(Bool, (4,4))
A[5:8,5:8] = rand(Bool, (4,4))
A[9:12,9:12] = rand(Bool, (4,4))
B = BipartiteNetwork(A)

using StatPlots
plotly()

[B |> lp |> x -> brim(x...) |> x -> Q(x...) for i in 1:2000] |>
  density
