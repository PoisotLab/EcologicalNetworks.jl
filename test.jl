include("./src/EcologicalNetwork.jl")
using EcologicalNetwork
using Base.Test
using StatsBase
using Distributions
using Plots, StatPlots

N = convert(BinaryNetwork, web_of_life("A_HP_001"))

all_n = simplify.(rand(null2(N), 200))
same_ric = filter(x -> richness(x) == richness(N), all_n)
same_lnk = filter(x -> links(x) == links(N), same_ric)

nest = (x) -> η(x)[:network]

nest(N).-nest.(all_n) |> density
nest(N).-nest.(same_ric) |> density!
nest(N).-nest.(same_lnk) |> density!
