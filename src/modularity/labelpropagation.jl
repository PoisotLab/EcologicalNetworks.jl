function lp{T<:BipartiteNetwork}(N::T)
  TL = collect(1:length(species(N,1)))
  BL = collect(1:length(species(N,2))).+richness(N,1)

  # Initial modularity
  imod = Q(N, TL, BL)
  amod = imod
  improved = true

  while improved
    order_t = shuffle(1:richness(N,1))
    order_b = shuffle(1:richness(N,2))

    for i in order_t
      linked = filter(j -> N[i,j], collect(1:richness(N,2)))
      labels = BL[linked]
      if length(labels) > 0
        counts = StatsBase.counts(BL[linked])
        cmax = maximum(counts)
        merged = Dict(zip(labels, counts))
        newlab = StatsBase.sample(collect(keys(Dict(collect(filter((k,v) -> v==cmax, merged))))))
        TL[i] = newlab
      end
    end

    for j in order_b
      linked = filter(i -> N[i,j], collect(1:richness(N,1)))
      labels = TL[linked]
      if length(labels) > 0
        counts = StatsBase.counts(TL[linked])
        cmax = maximum(counts)
        merged = Dict(zip(labels, counts))
        newlab = StatsBase.sample(collect(keys(Dict(collect(filter((k,v) -> v==cmax, merged))))))
        BL[j] = newlab
      end
    end

    # Modularity improved?
    amod = Q(N, TL, BL)
    imod, improved = amod > imod ? (amod, true) : (amod, false)
  end
  return (N, TL, BL)
end

function lp{T<:UnipartiteNetwork}(N::T)
  L = collect(1:length(species(N)))

  # Initial modularity
  imod = Q(N, L)
  amod = imod
  improved = true

  while improved

    order_s = shuffle(1:richness(N))

    for i in order_s
      linked = filter(j -> N[i,j], collect(1:richness(N)))
      labels = L[linked]
      if length(labels) > 0
        counts = StatsBase.counts(L[linked])
        cmax = maximum(counts)
        merged = Dict(zip(labels, counts))
        newlab = StatsBase.sample(collect(keys(Dict(collect(filter((k,v) -> v==cmax, merged))))))
        L[i] = newlab
      end
    end

    order_s = shuffle(1:richness(N))

    for i in order_s
      linked = filter(j -> N[j,i], collect(1:richness(N)))
      labels = L[linked]
      if length(labels) > 0
        counts = StatsBase.counts(L[linked])
        cmax = maximum(counts)
        merged = Dict(zip(labels, counts))
        newlab = StatsBase.sample(collect(keys(Dict(collect(filter((k,v) -> v==cmax, merged))))))
        L[i] = newlab
      end
    end

    # Modularity improved?
    amod = Q(N, L)
    imod, improved = amod > imod ? (amod, true) : (amod, false)
  end
  return (N, L)
end
