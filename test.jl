include("./src/EcologicalNetwork.jl")
using EcologicalNetwork
using Base.Test
using StatsBase
using Distributions
using Plots, StatPlots

N = convert(BinaryNetwork, web_of_life("A_HP_006"))

all_n = simplify.(rand(null2(N), 10000))
same_ric = filter(x -> richness(x) == richness(N), all_n)
same_lnk = filter(x -> links(x) == links(N), same_ric)

nest = (x) -> η(x)[:network]

z = (x0,x) -> (x.-x0)./(std(x))

cols = ["#e69f00", "#56b4df", "#009e73"]

density(z(nest(N), nest.(all_n)), lab="All networks", c=cols[1], fill=(cols[1], 0.2, 0), frame=:origin)
density!(z(nest(N), nest.(same_ric)), lab="Same S", c=cols[2], fill=(cols[2], 0.2, 0))
density!(z(nest(N), nest.(same_lnk)), lab="Same S, Same L", c=cols[3], fill=(cols[3], 0.2, 0))


p1 = N |> degree |> values |> collect |> sort |> x -> plot(x, c=:grey, leg=false)
for n in same_lnk
    n |> degree |> values |> collect |> sort |> x -> scatter!(p1, x, c=:red, ms=2)
end
N |> degree |> values |> collect |> sort |> x -> plot!(p1, x, c=:grey, lw=4)
p1
