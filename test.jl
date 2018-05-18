include("./src/EcologicalNetwork.jl")
using EcologicalNetwork
using StatsBase

begin
    using Base.Test
    using Distributions
    using Plots, StatPlots
end

B = convert(BinaryNetwork, web_of_life("A_HP_006"))
U = nz_stream_foodweb()[1]

sample(B, (2,))
sample(B, (2,2))
sample(B, 2)
sample(U, (2,))
sample(U, (2,2))
sample(U, 2)
