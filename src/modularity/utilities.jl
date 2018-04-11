"""
**Get the δ matrix**

    delta_matrix(N::AbstractEcologicalNetwork, L::Array{Int64, 1})

This matrix represents whether two nodes are part of the same module.
"""
function delta_matrix(N::AbstractBipartiteNetwork, TL::Array{Int64, 1}, BL::Array{Int64, 1})
  @assert length(TL) == richness(N,1)
  @assert length(BL) == richness(N,2)

  δ = TL .== BL'
  @assert size(δ) == size(N)

  # Return the 0/1 matrix
  return δ
end

function delta_matrix(N::AbstractUnipartiteNetwork, SL::Array{Int64, 1})
  @assert length(SL) == richness(N)

  δ = SL .== SL'
  @assert size(δ) == size(N)

  # Return the 0/1 matrix
  return δ
end

"""
**Modularity**

    Q(N::AbstractEcologicalNetwork, L::Array{Int64, 1})

This measures modularity based on a matrix and a list of module labels. Note
that this function assumes that interactions are directional, so that
``A_{ij}`` represents an interaction from ``i`` to ``j``, but not the other way
around.
"""
function Q(N::AbstractBipartiteNetwork, TL::Array{Int64, 1}, BL::Array{Int64, 1})
  @assert length(TL) == richness(N,1)
  @assert length(BL) == richness(N,2)

  # Communities matrix
  δ = delta_matrix(N, TL, BL)

  # Degrees
  dkin, dkout = degree_in(N), degree_out(N)
  kin = map(x -> dkin[x], species(N,2))
  kout = map(x -> dkout[x], species(N,1))

  # Value of m -- sum of weights, total number of int, ...
  m = links(N)

  # Null model
  kikj = (kout .* kin')
  Pij = kikj ./ m

  # Difference
  diff = N.A .- Pij

  # Diff × delta
  dd = diff .* δ

  return sum(dd)/m
end

function Q(N::AbstractUnipartiteNetwork, SL::Array{Int64, 1})
  @assert length(SL) == richness(N)

  # Communities matrix
  δ = delta_matrix(N, SL)

  # Degrees
  dkin, dkout = degree_in(N), degree_out(N)
  kin = map(x -> dkin[x], species(N,2))
  kout = map(x -> dkout[x], species(N,1))

  # Value of m -- sum of weights, total number of int, ...
  m = links(N)

  # Null model
  kikj = (kout .* kin')
  Pij = kikj ./ m

  # Difference
  diff = N.A .- Pij

  # Diff × delta
  dd = diff .* δ

  return sum(dd)/m
end

"""
**Realized modularity**

    Qr(N::AbstractEcologicalNetwork, L::Array{Int64, 1})

Measures realized modularity, based on a  a matrix and a list of module labels.
Realized modularity usually takes values in the [0;1] interval, and is the
proportion of interactions established *within* modules.

The realized modularity is defined as ``Q_R' = 2\times (W/E) - 1``, where ``W``
is the number of links *within* modules, and ``E`` is the total number of links.

Note that in some situations, `Qr` can be *lower* than 0. This reflects a
partition in which more links are established between than within modules.
"""
function Qr(N::AbstractUnipartiteNetwork, SL::Array{Int64, 1})
  @assert length(SL) == richness(N)
  δ = delta_matrix(N, SL)
  W = sum(N.A .* δ)
  E = links(N)
  return 2.0 * (W/E) - 1.0
end

function Qr(N::AbstractBipartiteNetwork, TL::Array{Int64, 1}, BL::Array{Int64, 1})
  @assert length(TL) == richness(N,1)
  @assert length(BL) == richness(N,2)
  δ = delta_matrix(N, TL, BL)
  W = sum(N.A .* δ)
  E = links(N)
  return 2.0 * (W/E) - 1.0
end

"""
**Most common labels**

    most_common_label(N::ProbabilisticNetwork, L, sp)

Arguments are the network, the community partition, and the species id
"""
function most_common_label(N::ProbabilisticNetwork, L, sp)

  # If this is a bipartite network, the margin should be changed
  pos_in_L = typeof(N) <: AbstractBipartiteNetworkBipartite ? size(N.A, 1) + sp : sp

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
  return sample(uni_nei_lab, Weights(f), 1)[1]

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
