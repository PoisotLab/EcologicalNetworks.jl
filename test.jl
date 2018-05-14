include("./src/EcologicalNetwork.jl")
using EcologicalNetwork

N = web_of_life("A_HP_002")

import Base: isless



null2(convert(BinaryNetwork, N)) .< 0.5
