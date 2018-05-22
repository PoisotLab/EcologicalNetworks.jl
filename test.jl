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
