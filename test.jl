include("./src/EcologicalNetwork.jl")
using EcologicalNetwork
using StatsBase
using NamedTuples

begin
    using Base.Test
    using Distributions
    using Plots, StatPlots
end

N = simplify(first(nz_stream_foodweb()))
Y = rand(null2(N), 10000)
Y = simplify.(Y)
Y = filter(y -> links(y) == links(N), Y)

m = map(x -> length(find_motif(N, unipartitemotifs()[:S2])), Y)

m0 = length(find_motif(N, unipartitemotifs()[:S2]))
