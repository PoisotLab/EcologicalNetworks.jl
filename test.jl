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
u = unipartitemotifs()


Profile.clear()
@profile find_motif(U, u[:S1])
Juno.profiletree()
Juno.profiler()

@time find_motif(U, u[:S1])
