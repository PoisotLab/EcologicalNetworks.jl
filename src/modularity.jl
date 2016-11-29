"""
Type to store a community partition

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
Get the δ matrix, representing whether two nodes are part of the same module.
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
Q -- a measure of modularity

This measures Barber's bipartite modularity based on a `Partition` object, and
update the object in the proccess.
"""
function Q(P::Partition)
  P.Q = Q(P.N, P.L)
  P.Q
end

"""
Qr -- a measure of realized modularity

Measures Poisot's realized modularity, based on a  a matrix and a list of module
labels. Realized modularity takes values in the [0;1] interval, and is the
proportion of interactions established *within* modules.

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
Qr -- a measure of realized modularity

Measures Poisot's realized modularity, based on a `Partition` object.
"""
function Qr(P::Partition)
  return Qr(P.N, P.L)
end

"""
Count most common labels

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
Count most common labels

Arguments are the network, the community partition, and the species id
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
Count most common labels

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
Performs label propagation in an `EcoNetwork`.
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

"""
This function is a wrapper for the modularity code. The number of replicates is
the number of times the modularity optimization should be run. By default, it
uses `label_propagation`.

Arguments:
1. `N::EcoNetwork`, the network to work on
2. `L::Array{Int64,1}`, an array of module identities

Keywords:
- `replicates::Int64`, defaults to `100`
"""
function modularity(N::EcoNetwork, L::Array{Int64, 1}; replicates::Int64=100)

    # Each species must have an entry
    @assert length(L) == richness(N)

    # We just pmap the label propagation function
    partitions = pmap((x) -> label_propagation(N, copy(L)), 1:replicates)

    # And return
    return partitions
end

"""
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
    return best_pos

end
