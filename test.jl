include("./src/EcologicalNetwork.jl")
using EcologicalNetwork

import Base.union, Base.intersection, Base.setdiff

Tr = map(n -> convert(BinaryNetwork, n), trojelsgaard_et_al_2014())

import Base.union
import Base.intersect
import Base.setdiff
