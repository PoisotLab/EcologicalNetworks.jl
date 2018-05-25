using Revise # To avoid reloading the session while we test things
include("./src/EcologicalNetwork.jl")
using EcologicalNetwork
using StatsBase
using NamedTuples
using Combinatorics

begin
    using JuliaDB
    using Base.Test
    using Distributions
    using Plots, StatPlots
end

# Important for benchmark
srand(2000)

ref_net = simplify(BipartiteNetwork(rand(Bool, (20,15))))
while richness(ref_net) != 35
    ref_net = simplify(BipartiteNetwork(rand(Bool, (20,15))))
end


Profile.clear()
@profiler find_motif(ref_net, BipartiteNetwork([true true; false true]))
