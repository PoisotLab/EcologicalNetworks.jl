include("./src/EcologicalNetwork.jl")
Pkg.add(pwd())
using EcologicalNetworks
using Traceur
using StatsBase
using NamedTuples
using StatPlots

N = nz_stream_foodweb()[5]

Profile.clear()
@time shuffle(N, number_of_swaps=5)
@profile shuffle(N, number_of_swaps=500)
Juno.profiler()
