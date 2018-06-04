using Revise # To avoid reloading the session while we test things
include("./src/EcologicalNetwork.jl")
using EcologicalNetwork
using StatsBase
using NamedTuples
using Combinatorics
using Base.Test

N = web_of_life("A_HP_001")
N = nz_stream_foodweb()[1]
N = convert(BinaryNetwork, N)

s = (6,6)

seed = sample(interactions(N))
sp = typeof(N) <: AbstractBipartiteNetwork ? ([seed.from], [seed.to]) : ([seed.from, seed.to],)
n = N[sp...]

# What can we add?
possible_additions = filter(i -> (i.from ∈ species(n,1))|(i.to ∈ species(n,2)), interactions(N))
filter!(i -> !(i ∈ interactions(n)), possible_additions)

add = length(possible_additions) == 0 ? sample(interactions(N)) : sample(possible_additions)
tentative_sp = typeof(N) <: AbstractBipartiteNetwork ? (vcat(species(n,1), [add.from]), vcat(species(n,2), [add.to])) : (unique(vcat(species(n), [add.from, add.to])),)
tentative_n = N[tentative_sp...]

if (richness(tentative_n, 1) <= first(s))&(richness(tentative_n, 2) <= last(s))
    sp = deepcopy(tentative_sp)
    n = N[sp...]
end

@time begin
    t = [reshape(sample(n.A, prod(size(n.A)), replace=false), size(n)) for i in 1:500000]
    t = unique(t)
    t = filter(x -> x != n.A, t)
    m = [typeof(n)(x, EcologicalNetwork.species_objects(n)...) for x in t]
    k1 = filter(z -> degree(z,1) == degree(n, 1), m)
    k2 = filter(z -> degree(z,2) == degree(n, 2), m)
    k12 = intersect(k1,k2)
end

n.A
