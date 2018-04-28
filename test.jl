include("./src/EcologicalNetwork.jl")
using EcologicalNetwork

wol = web_of_life()

retained = filter(x -> 20 <= x[:Species] <= 100, wol)
retained_ids = getfield.(retained, :ID)

for r in retained_ids
    println(r)
    web_of_life(r)
end

[try
    web_of_life(r)
end for r in retained_ids]
