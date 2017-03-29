"""
**Community partition**

This type has three elements:

- `N`, the network
- `L`, the array of (integers) module labels
- `Q`, if needed, the modularity value

"""
type Partition
    N::EcoNetwork
    L::Array{Int64, 1}
    Q::Float64
end

"""
Constructor for the `Partition` type from a `EcoNetwork` object.
"""
function Partition(N::EcoNetwork)
    tL = collect(1:richness(N))
    return Partition(N, tL)
end

"""
Constructor for the `Partition` type from an `EcoNetwork` object and an array
of module id.
"""
function Partition(N::EcoNetwork, L::Array{Int64, 1})
    @assert length(L) == richness(N)
    return Partition(N, L, Q(N, L))
end

"""
**Get the δ matrix**

    delta_matrix(N::EcoNetwork, L::Array{Int64, 1})

This matrix represents whether two nodes are part of the same module.
"""
function delta_matrix(N::EcoNetwork, L::Array{Int64, 1})
    @assert length(L) == richness(N)

    # The actual matrix depends on the shape of the network
    if typeof(N) <: Bipartite

        # If the network is bipartite, the L array is split in two
        R = L[1:nrows(N)]
        C = L[(nrows(N)+1):richness(N)]
        δ = R .== C'
    else
        # If the network is unipartite, we're good to go
        δ = L .== L'
    end

    # Return the 0/1 matrix
    return δ
end

"""
**Modularity**

    Q(N::EcoNetwork, L::Array{Int64, 1})

This measures modularity based on a matrix and a list of module labels. Note
that this function assumes that interactions are directional, so that
``A_{ij}`` represents an interaction from ``i`` to ``j``, but not the other way
around.
"""
function Q(N::EcoNetwork, L::Array{Int64, 1})
  # Easy case
  if length(unique(L)) == 1
    return 0.0
  end

  # Communities matrix
  δ = delta_matrix(N, L)

  # Degrees
  kin, kout = degree_in(N), degree_out(N)

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
**Modularity (from a `Partition`)**

    Q(P::Partition)

This measures Barber's bipartite modularity based on a `Partition` object, and
update the object in the proccess.
"""
function Q(P::Partition)
  P.Q = Q(P.N, P.L)
  P.Q
end

"""
**Realized modularity**

    Qr(N::EcoNetwork, L::Array{Int64, 1})

Measures realized modularity, based on a  a matrix and a list of module labels.
Realized modularity usually takes values in the [0;1] interval, and is the
proportion of interactions established *within* modules.

The realized modularity is defined as ``Q_R' = 2\times (W/E) - 1``, where ``W``
is the number of links *within* modules, and ``E`` is the total number of links.

Note that in some situations, `Qr` can be *lower* than 0. This reflects a
partition in which more links are established between than within modules.
"""
function Qr(N::EcoNetwork, L::Array{Int64, 1})
  if length(unique(L)) == 1
    return 0.0
  end

  δ = delta_matrix(N, L)
  W = sum(N.A .* δ)
  E = links(N)
  return 2.0 * (W/E) - 1.0
end


"""
**Realized modularity (from a `Partition`)**

    Qr(P::Partition)

Measures realized modularity, based on a `Partition` object.
"""
function Qr(P::Partition)
  return Qr(P.N, P.L)
end

"""
**Most common labels**

    most_common_label(N::DeterministicNetwork, L, sp)

Arguments are the network, the community partition, and the species id
"""
function most_common_label(N::DeterministicNetwork, L, sp)

  # If this is a bipartite network, the margin should be changed
  pos_in_L = typeof(N) <: Bipartite ? nrows(N) + sp : sp

  if sum(N[:,sp]) == 0
    return L[pos_in_L]
  end

  # Get positions with interactions
  nei = [i for i in eachindex(N[:,sp]) if N[i,sp]]

  # Labels of the neighbors
  nei_lab = L[nei]
  uni_nei_lab = unique(nei_lab)

  # Count
  f = zeros(Int64, size(uni_nei_lab))
  for i in eachindex(uni_nei_lab)
    f[i] = sum(nei_lab .== uni_nei_lab[i])
  end

  # Argmax
  local_max = maximum(f)
  candidate_labels = [uni_nei_lab[i] for i in eachindex(uni_nei_lab) if f[i] == local_max]

  # Return
  return L[pos_in_L] ∈ candidate_labels ? L[pos_in_L] : sample(candidate_labels)

end

"""
**Detect modules in a network**

    modularity(N::EcoNetwork, L::Array{Int64, 1}, f::Function; replicates::Int64=100)

This function is a wrapper for the modularity code. The number of replicates is
the number of times the modularity optimization should be run.

Arguments:
1. `N::EcoNetwork`, the network to work on
2. `L::Array{Int64,1}`, an array of module identities
3. `f::Function`, the function to use

Keywords:
- `replicates::Int64`, defaults to `100`

The function `f` *must* (1) accept `N, L` as arguments, and (2) return a
`Partition` as an output.
"""
function modularity(N::EcoNetwork, L::Array{Int64, 1}, f::Function; replicates::Int64=100)

  # Each species must have an entry
  @assert length(L) == richness(N)

  # We just pmap the label propagation function
  partitions = pmap((x) -> f(N, copy(L)), 1:replicates)

  # And return
  return partitions
end

"""
**Most modular partition**

    best_partition(modpart; f::Function=Q)

Return the best partition out of a number of replicates. This returns an
*array* of partitions. If there is a single partition maximizing the given
function `f` (as a keyword), the results are *still* returned as an array with
a single element.

Arguments:
1. `modpart::Array{Partition,1}`, an array of partitions returned by *e.g.*
   `modularity`

Keywords:
- `f::Function`, either `Q` or `Qr` (any function for which the highest value
   represents a more modular structure).
"""
function best_partition(modpart; f::Function=Q)

  # Tests on inputs
  @assert prod(map(x -> typeof(x) <: Partition, modpart))

  # We get the values of the "best" criteria
  crit = map(f, modpart)

  # And the positions of the matching partitions
  best_pos = collect(1:length(crit))[crit .== maximum(crit)]

  # Then return the best partitions
  return modpart[best_pos]

end
