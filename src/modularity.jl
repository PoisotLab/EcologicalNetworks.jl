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
Constructor for the `Partition` type
"""
function Partition(N::EcoNetwork)
    t_L = 1:richness(N)
    return Partition(N, t_L, Q(N, t_L))
end

"""
Constructor for the `Partition` type
"""
function Partition(N::EcoNetwork, L::Array{Int64, 1})
    @assert length(L) == richness(N)
    return Partition(N, L, Q(N, L))
end

"""
Q -- a measure of modularity

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

    # Same community?
    if typeof(N) <: Bipartite
        # In the case of bipartite networks the block A of the δ matrix is
        # considered:
        # 0 A
        # 0 0
        L_up = L[1:size(N.A, 1)]
        L_lo = L[(size(N.A, 1)+1):richness(N)]
        δ = L_up .== L_lo'
    else 
        δ = L .== L'
    end

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
    if typeof(N) <: Bipartite
        L_up = L[1:size(N.A, 1)]
        L_lo = L[(size(N.A, 1)+1):richness(N)]
        δ = L_up .== L_lo'
    else 
        δ = L .== L'
    end
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
    pos_in_L = typeof(N) <: Bipartite ? size(N.A, 1) + sp : sp

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
        have_this_label = [N[j,sp] for j in eachindex(L) if L[j] == uni_nei_lab[i]]
        f[i] = sum(have_this_label)
    end

    # Return (sampled by weight of unique labels)
    return sample(uni_nei_lab, WeightVec(f), 1)

end

"""
A **very** experimental label propagation method for probabilistic networks

This function is a take on the usual LP method for community detection. Instead
of updating labels by taking the most frequent in the neighbors, this algorithm
takes each interaction, and transfers the label across it with a probability
equal to the probability of the interaction. It is therefore *not* generalizable
for non-probabilistic networks.

The other pitfall is that there is a need to do a *large* number of iterations
to get to a good partition. This method is also untested.
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
        if typeof(N) <: Bipartite
            update_order_col = shuffle(1:size(N.A, 1))
            update_order_row = shuffle((size(N.A, 1)+1):richness(N)).-size(N.A, 1)
        else
            update_order_col = shuffle(1:size(N.A, 1))
            update_order_row = shuffle(1:size(N.A, 2))
        end

        # Update the rows
        for ur in update_order_row
            pos = typeof(N) <: Bipartite ? size(N.A, 1) + ur : ur
            L[pos] = most_common_label(N, L, ur)
        end

        # Update the columns
        for uc in update_order_col
            if typeof(N) <: Bipartite 
                cols = size(N.A, 1) .+ (1:size(N.A, 2))
                rows = 1:size(N.A, 1)
                tL = L[vcat(cols, rows)]
            else
                tl = L
            end
            L[uc] = most_common_label(N', tL, uc)
        end

        # Modularity improved?
        amod = Q(N, L)
        imod, improved = amod > imod ? (amod, true) : (amod, false)

    end
    return Partition(N, L)
end

"""
This function is a wrapper for the modularity code. The number of replicates is
the number of times the modularity optimization should be run.

Non-keywords arguments:

1. `N`, a network
2. `L`, an array of module id


Keywords arguments:

1. `replicates`, defaults to `100`
"""
function modularity(N::EcoNetwork, L::Array{Int64, 1}; replicates=100)
    @assert length(L) == richness(N)
    q = zeros(replicates)
    # First trial
    best_partition = label_propagation(N, L)
    q[i] = best_partition.Q
    for trial in 2:replicates
        trial_partition = label_propagation(N, L)
        q[trial] = trial_partition.Q
        if trial_partition.Q > best_partition.Q
            best_partition = trial_partition
        end
    end
    Q(best_partition)
    return [best_partition, q]
end

