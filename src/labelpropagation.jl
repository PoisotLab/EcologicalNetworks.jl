"""
**Most common labels**

    most_common_label(N::ProbabilisticNetwork, L, sp)

Arguments are the network, the community partition, and the species id.
"""
function most_common_label(N::ProbabilisticNetwork, L, sp)

  # If this is a bipartite network, the margin should be changed
  pos_in_L = typeof(N) <: Bipartite ? size(N.A, 1) + sp : sp

  if sum(N[:,sp]) == 0
    return L[pos_in_L]
  end

  # Get positions with interactions
  nei = [i for i in eachindex(N[:,sp]) if N[i,sp] > 0.0]

  # Labels of the neighbors
  nei_lab = L[nei]
  uni_nei_lab = unique(nei_lab)

  # Count
  f = zeros(Float64, size(uni_nei_lab))
  for i in eachindex(uni_nei_lab)
    have_this_label = [N[j,sp] for j in 1:nrows(N) if L[j] == uni_nei_lab[i]]
    f[i] = sum(have_this_label)
  end

  # Return (sampled by weight of unique labels)
  return sample(uni_nei_lab, WeightVec(f), 1)[1]

end

"""
**Most common labels**

    most_common_label(N::QuantitativeNetwork, L, sp)

Arguments are the network, the community partition, and the species id
"""
function most_common_label(N::QuantitativeNetwork, L, sp)

  # If this is a bipartite network, the margin should be changed
  pos_in_L = typeof(N) <: Bipartite ? size(N.A, 1) + sp : sp

  if sum(N[:,sp]) == 0
    return L[pos_in_L]
  end

  # Get positions with interactions
  nei = [i for i in eachindex(N[:,sp]) if N[i,sp] > 0.0]

  # Labels of the neighbors
  nei_lab = L[nei]
  uni_nei_lab = unique(nei_lab)

  # Count
  # HACK to get the type of the inner elements
  itype = typeof(N[1,1])
    f = zeros(itype, size(uni_nei_lab))
    for i in eachindex(uni_nei_lab)
      have_this_label = [N[j,sp] for j in 1:nrows(N) if L[j] == uni_nei_lab[i]]
      f[i] = sum(have_this_label)
    end

    # Argmax
    local_max = maximum(f)
    candidate_labels = [uni_nei_lab[i] for i in eachindex(uni_nei_lab) if f[i] == local_max]

    # Return
    return L[pos_in_L] ∈ candidate_labels ? L[pos_in_L] : sample(candidate_labels)

end

"""
**Label propagation**

    label_propagation(N::EcoNetwork, L::Array{Int64, 1})
"""
function label_propagation(N::EcoNetwork, L::Array{Int64, 1})

  # There must be one label per species
  @assert length(L) == richness(N)

  # Initial modularity
  imod = Q(N, L)
  amod = imod
  improved = true

  # Update
  while improved

    # Random update order -- identity of possible species varies between
    # bipartite and unipartite networks

    # The naming in this part of the code is a bit weird, so here goes: the
    # labels are updated column-wise, because the interactions are from the
    # species in the row, to the species in the column. So when we want to
    # know which row to update, the relevant information is actually in the
    # column id.
    update_order_col = shuffle(1:nrows(N))
    update_order_row = shuffle(1:ncols(N))

    # Update the rows
    for ur in update_order_row

      # The real position of the updated column must be corrected if we
      # are talking about a bipartite network. Column 1 is, in fact, the
      # nrows(N)+1th element of the community vector L.
      pos = typeof(N) <: Bipartite ? nrows(N) + ur : ur

      # When this is done, we can get the most common label. If this is
      # a bipartite network, since R and C are views instead of duplicate
      # arrays, everything will be kept up to date.
      L[pos] = most_common_label(N, L, ur)

    end

    # Update the columns
    for uc in update_order_col

      # If the network is bipartite, we need to move things around in the
      # L array. Specifically, since we transpose the matrix, the columns
      # need to come first.
      if typeof(N) <: Bipartite
        R = 1:nrows(N)
        C = nrows(N).+(1:ncols(N))
        vec_to_use = vcat(L[C], L[R])
      else
        vec_to_use = L
      end

      # Update
      L[uc] = most_common_label(N', vec_to_use, uc)
    end

    # Modularity improved?
    amod = Q(N, L)
    imod, improved = amod > imod ? (amod, true) : (amod, false)

  end
  return Partition(N, L)
end
