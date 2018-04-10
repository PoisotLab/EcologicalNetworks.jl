"""
**Get the δ matrix**

    delta_matrix(N::AbstractEcologicalNetwork, L::Array{Int64, 1})

This matrix represents whether two nodes are part of the same module.
"""
function delta_matrix(N::AbstractEcologicalNetwork, L::Array{Int64, 1})
    @assert length(L) == richness(N)

    # The actual matrix depends on the shape of the network
    if typeof(N) <: AbstractBipartiteNetwork
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

    modularity(N::AbstractEcologicalNetwork, L::Array{Int64, 1}, f::Function; replicates::Int64=100)

This function is a wrapper for the modularity code. The number of replicates is
the number of times the modularity optimization should be run.

Arguments:
1. `N::AbstractEcologicalNetwork`, the network to work on
2. `L::Array{Int64,1}`, an array of module identities
3. `f::Function`, the function to use

The function `f` *must* (1) accept `N, L` as arguments, and (2) return a
`Partition` as an output. Note that by default, `L` will be set to `nothing`,
and modules will be generated at random. In unipartite networks, there can
be up to one module per species. In bipartite networks, the minimum number
of modules is the richness of the less speciose level.

Keywords:
- `replicates::Int64`, defaults to `100`

"""
function modularity(N::AbstractEcologicalNetwork, L::Union{Void,Array{Int64, 1}}=nothing, f::Function=label_propagation; replicates::Int64=100)

  # Each species must have an entry
  @assert length(L) == richness(N)

  # Start with a random partition if there are none
  L_container = map(x -> L == nothing ? rand(1:minimum(size(N)), richness(N)) : copy(L), 1:replicates)

  # We just pmap the label propagation function
  partitions = pmap(x -> f(N, x), L_container)

  # And return
  return partitions
end

"""
**Average of non-zero values**

Used for network roles.
"""
function nonzeromean(x)
  mean(filter(k -> k!=0, x))
end

"""
**Standard deviation of non-zero values**

Used for network roles.
"""
function nonzerostd(x)
  std(filter(k -> k!=0, x))
end

"""
**Network roles based on modularity**

~~~ julia
networkroles(P::Partition)
~~~
"""
function networkroles(P::Partition; cutoff_z::Float64=2.5, cutoff_c::Float64=0.62)

  N = typeof(P.N) <: Bipartite ? make_unipartite(P.N) : P.N
  N = typeof(N) <: DeterministicNetwork ? N : adjacency(N)

  K = (N.A' .| N.A)

  l = unique(P.L)
  S = P.L .== l'

  by_sp_by_module = K*S

  # Z
  own_degree = sum(by_sp_by_module, 2)
  degree_in_own_module = by_sp_by_module[S]
  only_own_module = by_sp_by_module.*S
  # The next two are represented as matrices
  mean_ks = mapslices(nonzeromean, only_own_module, 1).*S
  std_ks = mapslices(nonzerostd, only_own_module, 1).*S

  # Finally
  z_as_matrix = (only_own_module .- mean_ks)./(std_ks)
  z = (z_as_matrix.*S)[S]

  # Diagonal = degree for each module
  degree_by_module = diag(by_sp_by_module'*S)

  # C
  c = 1.-sum((by_sp_by_module./own_degree).^2,2)

  return hcat(z,c)

end
