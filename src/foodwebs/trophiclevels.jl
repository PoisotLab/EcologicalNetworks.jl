function fractional_trophic_level{T<:UnipartiteNetwork}(N::T)
  Y = nodiagonal(N)
  tl = Dict(zip(species(Y), zeros(Int64, richness(Y))))
  d_in, d_out = degree_in(Y), degree_out(Y)
  primary_producers = collect(keys(filter((k,v) -> v == 0, d_out)))
  for pp_sp in primary_producers
    tl[pp_sp] = 1
  end

  updated = true
  current_tl = 1

  while updated
    updated = false
    preys_of_current_rank = filter(s -> tl[s].==current_tl, species(Y))
    if length(preys_of_current_rank) > 0
      updated = true
      for s in species(N,1)
        for p in preys_of_current_rank
          if has_interaction(Y, s, p)
            tl[s] = current_tl+1
          end
        end
      end
    end
    current_tl = current_tl+1
  end

  return tl
end
