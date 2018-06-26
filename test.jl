using Revise # To avoid reloading the session while we test things
include("./src/EcologicalNetwork.jl")
using EcologicalNetwork
using StatsBase
using NamedTuples
using Combinatorics
using Base.Test

N = convert(BinaryNetwork, web_of_life("A_HP_001"))

Profile.clear()
@time nodf(N)
[@profile nodf(N) for i in 1:1000]
Juno.profiler()
