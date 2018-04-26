include("./src/EcologicalNetwork.jl")
using EcologicalNetwork

  true true true false false false; true true true false false false;
  A = [
  false false false true true true; false false false true true true
  ]

A = zeros(Bool, (12,12))
A[1:4,1:4] = rand(Bool, (4,4))
A[5:8,5:8] = rand(Bool, (4,4))
A[9:12,9:12] = rand(Bool, (4,4))

B = simplify(UnipartiteNetwork(A))
