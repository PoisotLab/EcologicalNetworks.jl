using Revise # To avoid reloading the session while we test things
include("./src/EcologicalNetwork.jl")
using EcologicalNetwork
using StatsBase
using NamedTuples
using Combinatorics
using Base.Test
using StatPlots

N = convert(BinaryNetwork, web_of_life("M_PA_002"))

n0 = nodf(N)
S = 3000
stepsize = 5
sd = zeros(Float64, S)
sl = zeros(Float64, S)
si = zeros(Float64, S)
so = zeros(Float64, S)
Yd = copy(N)
Yl = copy(N)
Yi = copy(N)
Yo = copy(N)
@progress for i in 1:S
  Yd = shuffle(Yd; number_of_swaps=stepsize)
  Yl = shuffle(Yl; number_of_swaps=stepsize, constraint=:fill)
  Yi = shuffle(Yi; number_of_swaps=stepsize, constraint=:vulnerability)
  Yo = shuffle(Yo; number_of_swaps=stepsize, constraint=:generality)
  sd[i] = nodf(Yd)
  sl[i] = nodf(Yl)
  si[i] = nodf(Yi)
  so[i] = nodf(Yo)
end

function rn(N, f, n)
  nets = N |> f |> x -> rand(x, n) .|> simplify
  filter!(x -> richness(x) == richness(N), nets)
  filter!(x -> links(x) == links(N), nets)
  return nets
end

dd = nodf.(rn(N, null2, 50_000))
dl = nodf.(rn(N, null1, 50_000))
di = nodf.(rn(N, null3in, 50_000))
dO = nodf.(rn(N, null3out, 50_000))

sd = sd[(end-1000):end]
sl = sl[(end-1000):end]
si = si[(end-1000):end]
so = so[(end-1000):end]

for s in [sl, si, so, sd, dd, dl, di, dO]
  filter!(.!isnan, s)
end

pld = density(sd, fill=(:blue, 0, 0.4), legend=:topleft, lw=0, leg=false)
density!(pld, dd, fill=(:orange, 0, 0.4), lw=0)
title!(pld, "Degree distribution")

pll = density(sl, fill=(:blue, 0, 0.4), legend=:topleft, lw=0, lab="Interaction swap")
density!(pll, dl, fill=(:orange, 0, 0.4), lw=0, lab="Random draws")
title!(pll, "Connectance")

pli = density(si, fill=(:blue, 0, 0.4), legend=:topleft, lw=0, leg=false)
density!(pli, di, fill=(:orange, 0, 0.4), lw=0)
title!(pli, "Vulnerability")

plo = density(so, fill=(:blue, 0, 0.4), legend=:topleft, lw=0, leg=false)
density!(plo, dO, fill=(:orange, 0, 0.4), lw=0)
title!(plo, "Generality")

for pl in [plo, pli, pll, pld]
  yaxis!(pl, (0,25))
  xaxis!(pl, (0,1))
  scatter!(pl, [n0],[0.5], c=:black, msw=0, ms=8, m=:dtriangle, lab="Original value")
end

plot(pll, pld, plo, pli)
