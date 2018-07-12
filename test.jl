include("./src/EcologicalNetwork.jl")
using EcologicalNetwork
using Traceur
using StatsBase
using NamedTuples
using StatPlots

N = web_of_life("A_HP_002")
Traceur.@trace connectance(N)
Traceur.@trace degree(N, 1)
