"""
**Inner loop for the Louvain modularity, step 1**

    louvain_s1_inner(Y::NonProbabilisticNetwork, L::Array{Int64, 1})

"""
function louvain_s1_inner(Y::DeterministicNetwork, L::Array{Int64, 1})
  Q0 = Q(Y, L)
  Lnew = copy(L)
  for i in eachindex(L)
    ΔQ = zeros(length(L))
    for j in eachindex(L)
      l = copy(L)
      if has_interaction(Y, i, j)
        l[i] = l[j]
        ΔQ[j] = Q(Y, l) - Q0
      end
    end
    # We move only if there is an optimum
    if maximum(ΔQ) > 0.0
      max_id = filter(x -> ΔQ[x] == maximum(ΔQ), 1:length(ΔQ))[1]
      Lnew[i] = Lnew[max_id]
    end
  end
  return Lnew
end

"""
**Inner loop for the Louvain modularity, step 2**
"""
function louvain_s2_inner(Y::DeterministicNetwork, L::Array{Int64, 1})

  # Aggregate the network
  c_id = unique(L)
  c = length(c_id)
  K = UnipartiteQuantiNetwork(zeros(Int64, (c, c)))
  c_of = map(i -> filter(x -> c_id[x] == L[i], 1:length(c_id))[1], 1:length(L))
  c_id = collect(1:length(c_id))
  for i in 1:richness(Y)
    for j in 1:richness(Y)
      K[c_of[i], c_of[j]] += Y[i, j]
    end
  end

  return (K, c_of)
end


"""
**Performs one internal Louvain step**

    louvain_one_step(Y::NonProbabilisticNetwork, L::Array{Int64, 1})

"""
function louvain_one_step(Y::DeterministicNetwork, L::Array{Int64, 1})

  # Phase 1
  Q0 = Q(Y, L)

  improved = true
  while improved
    L = louvain_s1_inner(Y, L)
    improved = Q0 < Q(Y, L)
    Q0 = improved ? Q(Y, L) : Q0
  end

  # Phase 2
  K, l = louvain_s2_inner(Y, L)

  return (K, l)
end

"""
**Louvain method for modularity on large networks**

    louvain(N::NonProbabilisticNetwork, L::Array{Int64, 1})

TODO
"""
function louvain(N::DeterministicNetwork, L::Array{Int64, 1})
  Y = typeof(N) <: AbstractUnipartiteNetwork ? copy(N) : convert(AbstractUnipartiteNetwork, N)

  m_collector = hcat(copy(L))

  improve = true
  while improve
    Yl, Ll = louvain_one_step(Y, L)
    if length(Ll) == size(m_collector, 1)
      m_collector = hcat(m_collector, Ll)
    else
      m_collector = hcat(m_collector, Ll[m_collector[:,size(m_collector, 2)]])
    end
    Y = copy(Yl)
    L = collect(1:richness(Y))
    improve = Q(N, m_collector[:,size(m_collector, 2)]) > Q(N, m_collector[:,size(m_collector, 2)-1])
  end

  return Partition(N, m_collector[:,size(m_collector, 2)])
end
