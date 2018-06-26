using Revise # To avoid reloading the session while we test things
include("./src/EcologicalNetwork.jl")
using EcologicalNetwork
using StatsBase
using NamedTuples
using Combinatorics
using Base.Test
using StatPlots

N = convert(BinaryNetwork, web_of_life("A_HP_001"))

n0 = nodf(N)
stepsize = 5
no = zeros(Float64, 8000)
Y = copy(N)
@progress for i in eachindex(no)
  Y = shuffle(Y, number_of_swaps=stepsize)
  no[i] = nodf(Y)
end

nets = N |> null2 |> x -> rand(x, 100_000) .|> simplify
filter!(x -> richness(x) == richness(N), nets)
filter!(x -> links(x) == links(N), nets)
np = nodf.(nets)
ns = no[(end-500):end]

density(ns, bins=30, lab="Swaps", frame=:ticks, c="#9a3a9f", lw=2, fill=("#9a3a9f", 0, 0.5), legend=:topleft)
density!(np, bins=30, lab="Draws", c="#356637", lw=2, fill=("#356637", 0, 0.5))
vline!([n0], lab="Observed", c="#333", ls=:dash, lw=3)
yaxis!((0,30))


scatter(no[2:end], no[1:(end-1)])
xaxis!((0,1))
yaxis!((0,1))
