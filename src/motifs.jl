"""
Take a bipartite network, returns a collection of unique permutations
"""
function permute_network(N::Bipartite)

    # Prepare to store the hashes
    hashes = UInt64[]

    # Prepare to store the unique networks
    uniques = typeof(N)[]

    # Get the margins
    col_margin, row_margin = 1:ncols(N), 1:nrows(N)

    for rperm in permutations(row_margin)
        for cperm in permutations(col_margin)

            # Tentative network
            m_adj = N.A[vec(rperm), vec(cperm)]

            # Check the hash
            if hash(m_adj) ∈ hashes
                continue
            else
                # Now we know this network
                push!(hashes, hash(m_adj))
                # So we keep it
                push!(uniques, typeof(N)(m_adj))
            end
        end
    end
    return uniques
end

"""
Take a unipartite network, returns a collection of unique permutations
"""
function permute_network(N::Unipartite)

  # Prepare to store the hashes
  hashes = UInt64[]

  # Prepare to store the unique networks
  uniques = typeof(N)[]

  # Get the margins
  sp_margin = 1:richness(N)

  for iperm in permutations(sp_margin)

    # Tentative network
    m_adj = N.A[vec(iperm), vec(iperm)]

    # Check the hash
    if hash(m_adj) ∈ hashes
      continue
    else
      # Now we know this network
      push!(hashes, hash(m_adj))
      # So we keep it
      push!(uniques, typeof(N)(m_adj))
    end
  end

  return uniques
end

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
Probability that a group of species form a given motif. This works for both the
probabilistic and deterministic networks.
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

    # We will store the unique conformations of the permuted motifs using
    # hashes
    shuffled_motifs = permute_network(m)

    # Store the probabilities
    single_probas = Float64[]

    # Compute the probabilities for each k-plet
    n_r_perm = 1
    for cr in row_comb
        n_c_perm = 1
        for cc in col_comb
            for shmi in eachindex(shuffled_motifs)
                push!(single_probas,
                      motif_p(
                              typeof(N)(N[vec(cr), vec(cc)]),
                              shuffled_motifs[shmi]
                             )
                     )
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

    # We will store the unique conformations of the permuted motifs using
    # hashes
    shuffled_motifs = permute_network(m)

    # Store the probabilities
    single_probas = zeros(Float64, (length(sp_comb), length(shuffled_motifs)))

    # Compute the probabilities for each k-plet
    n_k_perm = 1
    for cr in sp_comb

        # We need to keeep track of which motif permutation this is
        n_m_perm = 1

        # We keep the subpart of the graph constant, but permute the motif
        # instead. This is faster and also avoids duplicating counts.
        for pr in eachindex(shuffled_motifs)
                single_probas[n_k_perm, pr] = motif_p(
                                            typeof(N)(N[vec(cr), vec(cr)]),
                                            shuffled_motifs[pr]
                                            )
        end
        n_k_perm += 1
    end

    return single_probas
end

"""
In a network `N`, counts the number of time a motif `m` appears. In the case of
a probabilistic network, `N` is the expected number of motifs. In the case of
a quantitative network, `N` is the number of times the motif appears in the
unweighted network.

Note that because self-edges (*a.k.a.* loops, or cannibalism) are *not* counted
in the motifs (the adjacency matrix is treated as if it had all diagonal
elements set to 0).

Arguments:
- `N::EcoNetwork`, the network in which to count the motifs
- `m::DeterministicNetwork`, the adjacency matrix of the motif
"""
function motif(N::EcoNetwork, m::DeterministicNetwork)

  # We make sure that there are no diagonal elements
  Y = nodiag(N)

  # If the nework is weighted, we start by removing the interaction strength
  # information
  if typeof(Y) <: QuantitativeNetwork
    return motif(adjacency(Y), m)
  else
    return sum(float(count_motifs(Y, m)))
  end
end

""" Expected variance of a given motif """
function motif_var(N::ProbabilisticNetwork, m::DeterministicNetwork)
  return a_var(float(count_motifs(N, m)))
end
