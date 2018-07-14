include("./src/EcologicalNetwork.jl")
using EcologicalNetwork
using Traceur
using StatsBase
using NamedTuples
using StatPlots

N = nz_stream_foodweb()[5]


bellman_ford(N)
