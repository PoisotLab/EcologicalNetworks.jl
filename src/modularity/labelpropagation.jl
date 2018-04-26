function lp{T<:AbstractEcologicalNetwork}(N::T)
  L = Dict([species(N)[i]=>i for i in 1:richness(N)])

  # Initial modularity
  imod = Q(N, L)
  amod = imod
  improved = true

  while improved
    update_t = shuffle(species(N,1))
    update_b = shuffle(species(N,2))

    for s1 in update_t
      linked = filter(s2 -> has_interaction(N,s1,s2), species(N,2))
      labels = [L[s2] for s2 in linked]
      if length(labels) > 0
        counts = StatsBase.counts(labels)
        cmax = maximum(counts)
        merged = Dict(zip(labels, counts))
        ok_keys = keys(Dict(collect(filter((k,v) -> v==cmax, merged))))
        if length(ok_keys) > 0
          newlab = StatsBase.sample(collect(ok_keys))
          L[s1] = newlab
        end
      end
    end

    for s2 in update_b
      linked = filter(s1 -> has_interaction(N,s1,s2), species(N,1))
      labels = [L[s1] for s1 in linked]
      if length(labels) > 0
        counts = StatsBase.counts(labels)
        cmax = maximum(counts)
        merged = Dict(zip(labels, counts))
        ok_keys = keys(Dict(collect(filter((k,v) -> v==cmax, merged))))
        if length(ok_keys) > 0
          newlab = StatsBase.sample(collect(ok_keys))
          L[s2] = newlab
        end
      end
    end

    # Modularity improved?
    amod = Q(N, L)
    imod, improved = amod > imod ? (amod, true) : (amod, false)
  end
  tidy_modules!(L)
  return (N, L)
end
