using Revise # To avoid reloading the session while we test things
include("./src/EcologicalNetwork.jl")
using EcologicalNetwork
using StatsBase
using NamedTuples
using Combinatorics

begin
    using Base.Test
    using Distributions
    using Plots, StatPlots
end

N = simplify(first(nz_stream_foodweb()))
N = convert(BinaryNetwork, web_of_life("A_HP_015"))

Y = copy(N)
m = BipartiteNetwork([true true; false true])

m0 = length(find_motif(Y, m))
P = null2(Y)
p0, v0 = expected_motif_count(find_motif(P, m))
Rs = rand(P, 20000)
filter!(R -> links(R) == links(Y), Rs)
filter!(R -> richness(R) == richness(Y), Rs)
filter!(R -> !isdegenerate(R), Rs)
r0 = length.(find_motif.(Rs, m))



# Track - Co, % degenerate, % same size, etc

Ss = [shuffle(Y, size_of_swap=(2,2)) for i in 1:500]
s0 = length.(find_motif.(Ss, m))

col = ["#e69600", "#56b4df", "#009e73"]

density(m0.-r0, fill=(0, 0.2), frame=:origin, lw=0.5, lab="Random draws", c=col[1], legend=:topright)
density!(m0.-s0, fill=(0, 0.2), lw=0.5, lab="Sub-matrix permutations", c=col[2])
density!(m0.-rand(Normal(p0, sqrt(v0)), 10000), lab="Probabilistic estimation", fill=(0, 0.2), lw=0.5, c=col[3])
xaxis!("Difference from measurement")
