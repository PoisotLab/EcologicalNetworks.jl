include("./src/EcologicalNetwork.jl")
using EcologicalNetwork
using Base.Test

N = first(nz_stream_foodweb())

import Base: eltype



eltype(web_of_life("A_HP_001"))
