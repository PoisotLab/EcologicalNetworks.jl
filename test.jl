include("src/EcologicalNetwork.jl")
using EcologicalNetwork
using Combinatorics

function permute_motif{T<:AbstractUnipartiteNetwork}(m::T)
    perm = []
    for s in permutations(species(m))
        push!(perm, m[s].A)
    end
    unique_perm = unique(perm)
    return unique_perm
end

function enumerate_motifs{T1<:UnipartiteNetwork,T2<:UnipartiteNetwork}(N::T1, m::T2)
    motif_permutations = permute_motif(m)
    matching_species = []
    for species_combination in combinations(species(N), richness(m))
        if N[species_combination].A ∈ motif_permutations
            push!(matching_species, (species_combination,))
        end
    end
    return matching_species
end

function permute_motif{T<:AbstractBipartiteNetwork}(m::T)
    perm = []
    for ts in permutations(species(m,1)), bs in permutations(species(m,2))
        push!(perm, m[ts,bs].A)
    end
    unique_perm = unique(perm)
    return unique_perm
end

function enumerate_motifs{T1<:BipartiteNetwork,T2<:BipartiteNetwork}(N::T1, m::T2)
    motif_permutations = permute_motif(m)
    matching_species = []
    for t_species_combination in combinations(species(N,1), richness(m,1)), b_species_combination in combinations(species(N,2), richness(m,2))
        if N[t_species_combination, b_species_combination].A ∈ motif_permutations
            push!(matching_species, (t_species_combination,b_species_combination))
        end
    end
    return matching_species
end
