include("./src/EcologicalNetwork.jl")
using EcologicalNetwork
using StatsBase
using NamedTuples
using StatPlots

N = BipartiteNetwork(rand((12,20)) .≤ 0.1)
K = copy(N)
L = simplify(N)
N.A == K.A
