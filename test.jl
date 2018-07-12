include("./src/EcologicalNetwork.jl")
using EcologicalNetwork
using StatsBase
using NamedTuples
using StatPlots

N = BipartiteNetwork(rand((21,99)) .≤ 0.2)
simplify!(N)

@time [brim(lp(N)...) for i in 1:20]
