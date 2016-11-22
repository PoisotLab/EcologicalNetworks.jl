"""
Internal motif calculations

The two arguments are `N` the network and `m` the motif adjacency matrix (as
a `DeterministicNetwork`). The two matrices must have the same size.  The
function returns a *vectorized* probability of each interaction being in the
right state for the motif, *i.e.* P if m is 1, and 1 - P if m is 0.
"""
function motif_internal(N::EcoNetwork, m::DeterministicNetwork)

    # The motif structure must have the same size than the partial adjacency
    # matrix
    @assert size(N) == size(m)

    # Check that the types are the same
    if typeof(N) <: Bipartite
        @assert typeof(m) <: Bipartite
    else
        @assert typeof(m) <: Unipartite
    end

    # Get the interaction-level probability of having the right motif
    # conformation
    b = zeros(Float64, size(m))
    b[!m.A] = 1.0
    b[m.A] = 2.0 .* N.A[m.A]

    # Finally, return this as an unfolded matrix.
    return vec(b .- N.A)

end

"""
Probability that a group of species form a given motif

This works for both the probabilistic and deterministic networks.
"""
function motif_p(N::EcoNetwork, m::DeterministicNetwork)
    return prod(motif_internal(N, m))
end

"""
Variance that a group of species form a given motif
"""
function motif_v(N::ProbabilisticNetwork, m::DeterministicNetwork)
    return m_var(motif_internal(N, m))
end

"""
Motif counter for a bipartite network

This function will go through all k-permutations of `N` to measure the
probability of each induced subgraph being an instance of the motif given by
`m` (the adjacency matrix of the motif, with 0 and 1). Note that the `k` is
determined by the dimensions of `n`.
"""
function count_motifs(N::Bipartite, m::DeterministicNetwork)

    # The motif must be no larger than N, and this must be true for all
    # dimensions
    @assert richness(N) >= richness(m)
    @assert nrows(N) >= nrows(m)
    @assert ncols(N) >= ncols(m)

    row_pick, col_pick = 1:nrows(N), 1:ncols(N)
    row_comb, col_comb = combinations(row_pick, nrows(m)), combinations(col_pick, ncols(m))

    # Store the probabilities
    single_probas = Float64[]

    # Compute the probabilities for each k-plet
    for cr in row_comb
        for cc in col_comb
            for pr in permutations(cr)
                for pc in permutations(cc)
                    push!(single_probas, motif_p(typeof(N)(N[vec(pr), vec(pc)]), m))
                end
            end
        end
    end
    
    return single_probas
end

"""
Motif counter for an unipartite network

This function will go through all k-permutations of `N` to measure the
probability of each induced subgraph being an instance of the motif given by
`m` (the adjacency matrix of the motif, with 0 and 1). Note that the `k` is
determined by the dimensions of `n`.
"""
function count_motifs(N::Unipartite, m::DeterministicNetwork)

    # The motif must be no larger than N
    @assert richness(N) >= richness(m)

    sp_pick = 1:richness(N)
    sp_comb = combinations(sp_pick, richness(m))

    # Store the probabilities
    single_probas = Float64[]

    # Compute the probabilities for each k-plet
    for cr in sp_comb
        for pr in permutations(cr)
            push!(single_probas, motif_p(typeof(N)(N[vec(pr), vec(pr)]), m))
        end
    end
    
    return single_probas
end

""" Expected number of a given motif """
function motif(N::EcoNetwork, m::DeterministicNetwork)
  return sum(float(count_motifs(N, m)))
end

""" Expected variance of a given motif """
function motif_var(A::Array{Float64, 2}, m::Array{Float64, 2})
  return a_var(float(count_motifs(A, m)))
end
