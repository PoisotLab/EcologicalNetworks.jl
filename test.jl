include("./src/EcologicalNetwork.jl")
using EcologicalNetwork
using Base.Test

using Distributions

d_host = LogNormal(2.0, 2.0)
d_parasite = LogNormal(2.2, 1.4)

N_host = sort(rand(d_host, 20))
N_parasite = sort(rand(d_parasite, 10))

N_host = N_host ./ sum(N_host)
N_parasite = N_parasite ./ sum(N_parasite)

NP = N_parasite.*N_host'


using StatsBase
n_int = sample(collect(eachindex(NP)), weights(vec(NP)), 2000)
A = zeros(Int64, NP)
for i in n_int
    A[i] += 1
end

N = BipartiteQuantitativeNetwork(A)
