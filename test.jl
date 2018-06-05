using Revise # To avoid reloading the session while we test things
include("./src/EcologicalNetwork.jl")
using EcologicalNetwork
using StatsBase
using NamedTuples
using Combinatorics
using Base.Test

N = convert(BinaryNetwork, web_of_life("A_HP_001"))
Ud = shuffle(N; number_of_swaps=10, constraint=:degree)

Profile.clear()
@profile shuffle(N; number_of_swaps=10, constraint=:degree)
Juno.profiler()
