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
