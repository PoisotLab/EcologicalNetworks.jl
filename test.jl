include("./src/EcologicalNetwork.jl")
using EcologicalNetwork

N = web_of_life("A_HP_002")

sp = first(species(N,1))

sp ∈ species(N,1)

filter(x -> has_interaction(N, sp, x), species(N,2))

x = first(species(N,2))

has_interaction(N, sp, x)

N.A

import Base: isless, !
