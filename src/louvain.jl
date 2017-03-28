"""
**Louvain method for modularity on large networks**

    louvain(N::NonProbabilisticNetwork, L::Array{Int64, 1})

TODO
"""
function louvain(N::NonProbabilisticNetwork, L::Array{Int64, 1})
  Y = typeof(N) <: Unipartite ? copy(N) : make_unipartite(N)
  L = collect(1:richness(Y))

  #=
  TODO this needs to be divided in two steps -- the phase 1, and the phase 2

  phase 2 essentially creates a weighted network -- for every info, we need a
  tuple with (L in, L out), to generate a giant table and assign the motifs in
  the end
  =#

  # Phase 1
  Q0 = Q(Y, L)
  Lnew = copy(L)
  for i in eachindex(L)
    ΔQ = zeros(length(L))
    for j in eachindex(L)
      l = copy(L)
      if Y[i,j]
        l[i] = l[j]
        ΔQ[j] = Q(Y, l) - Q0
      end
    end
    max_id = filter(x -> ΔQ[x] == maximum(ΔQ), 1:length(ΔQ))[1]
    Lnew[i] = Lnew[max_id]
  end

end
