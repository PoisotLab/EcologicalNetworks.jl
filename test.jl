include("src/EcologicalNetwork.jl")
using EcologicalNetwork
using Combinatorics

# Load the motifs
m = unipartitemotifs()

# Random network
a = rand(Bool, (100, 100))
N = UnipartiteNetwork(a)

mo = m[:S2]

perm = []

function permute_motif(m::UnipartiteNetwork)
    for s in permutations(species(mo))
        push!(perm, mo[s].A)
    end
    unique_perm = unique(perm)
    return unique_perm
end

richness(mo)

suc = []
per = permute_motif(mo)

@elapsed for co in combinations(species(N), richness(mo))
    isg = N[co]
    if isg.A ∈ per
        push!(suc, co)
    end
end

suc
