include("./src/EcologicalNetwork.jl")
using EcologicalNetwork

import Base.union, Base.intersection, Base.setdiff

Tr = map(n -> convert(BinaryNetwork, n), trojelsgaard_et_al_2014())

import Base.union
import Base.intersect
import Base.setdiff


X, Y = Tr[10:11]


circular_network_plot(N)

Tr[10:11] |> x -> intersect(x...) |> simplify
