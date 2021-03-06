"""
    lp(N::T) where {T<:AbstractEcologicalNetwork}

Uses label propagation to generate a first approximation of the modular
structure of a network. This is usually followed by the BRIM (`brim`) method.
This method supposedly performs better for large graphs, but we rarely observed
any differences between it and variations of BRIM alone on smaller graphs.

#### References

Liu, X., Murata, T., 2009. Community Detection in Large-Scale Bipartite
Networks, in: 2009 IEEE/WIC/ACM International Joint Conference on Web
Intelligence and Intelligent Agent Technology. Institute of Electrical &
Electronics Engineers (IEEE). https://doi.org/10.1109/wi-iat.2009.15
"""
"""
    lp(N::T) where {T<:AbstractEcologicalNetwork}

Uses label propagation to generate a first approximation of the modular
structure of a network. This is usually followed by the BRIM (`brim`) method.
This method supposedly performs better for large graphs, but we rarely observed
any differences between it and variations of BRIM alone on smaller graphs.

#### References

Liu, X., Murata, T., 2009. Community Detection in Large-Scale Bipartite
Networks, in: 2009 IEEE/WIC/ACM International Joint Conference on Web
Intelligence and Intelligent Agent Technology. Institute of Electrical &
Electronics Engineers (IEEE). https://doi.org/10.1109/wi-iat.2009.15
"""
function lp(N::T) where {T<:AbstractEcologicalNetwork}
  L = Dict([species(N)[i]=>i for i in 1:richness(N)])
  
  neighbors_b = Dict([s=>N[:,s] for s in species(N, dims=2)])
  neighbors_t = Dict([s=>N[s,:] for s in species(N, dims=1)])

  # Initial modularity
  imod = Q(N, L)
  amod = imod
  improved = true

  while improved
    update_t = shuffle(species(N; dims=1))
    update_b = shuffle(species(N; dims=2))

    for s1 in update_t
      linked = neighbors_t[s1]
      labels = [L[s2] for s2 in linked]
      if length(labels) > 0
        counts = Dict()
        (i->counts[i] = get(counts, i, 0) + 1).(labels)
        cmax = maximum(values(counts))
        ok_keys = keys(filter(k -> k.second==cmax, counts))
        if length(ok_keys) > 0
          newlab = StatsBase.sample(collect(ok_keys))
          L[s1] = newlab
        end
      end
    end

    for s2 in update_b
      linked = neighbors_b[s2]
      labels = [L[s1] for s1 in linked]
      if length(labels) > 0
        counts = Dict()
        (i->counts[i] = get(counts, i, 0) + 1).(labels)
        cmax = maximum(values(counts))
        ok_keys = keys(filter(k -> k.second==cmax, counts))
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

"""
    salp(N::T; θ::Float64=1.0, steps::Int64=10_000, λ::Float64=0.999, progress::Bool=false) where {T <: BipartiteNetwork}

Label-propagation using simulated annealing. This function uses simulated
annealing to propagate labels from neighboring nodes. It accepts a network as
input. The schedule of the simulated annealing is linear: at step k+1, the
temperature is θλᵏ. The initial temperature has been picked so that after 100
timesteps, using the default λ, a move decreasing modularity by 0.05 (20% of the
theoretical maximum) is picked with a probability of 0.1.

Optional arguments regulating the behavior of the simulated annealing
routine are:

- `λ=0.999`, the rate of temperature decay
- `θ=0.002`, the initial temperature
- `steps=10_000`, the number of annealing steps to perform
- `progress=false`, whether to display an info message every 100 timesteps

The θ parameter can be picked using the following method: if we want to allow a
maximal loss of modularity of δ, after timestep k, with a decay parameter λ,
with a probability P, then θ = -δ/[λᵏ×ln(P)]⁻¹. By beibg more or less
restrictive on these parameters, the user can pick a value of θ for every
problem.

This function can work as a first step (like `lp`), but in explorations during
the development of the package, we found that `brim` was rarely (if ever) able
to optmize the output further. It can therefore be used on its own.
"""
function salp(N::T; θ::Float64=0.002, steps::Int64=10_000, λ::Float64=0.999, progress::Bool=false) where {T <: BipartiteNetwork}
  Y = copy(N)
  m = last(each_species_its_module(N))

  Q0 = Q(Y, m)
  for step in 1:steps
    temperature = θ*λ^(step-1)
    update_side = rand() < 0.5 ? 1 : 2
    updated_species = rand(species(Y; dims=update_side))
    original_module = m[updated_species]
    neighbors = update_side == 1 ? N[updated_species,:] : N[:,updated_species]
    modules = [get(m, n, 0) for n in collect(neighbors)]
    m[updated_species] = rand(modules)
    QR = Q(Y, m)
    Δ = Q0 - QR
    if rand() ≤ exp(-Δ/temperature)
      Q0 = QR
    else
      m[updated_species] = original_module
    end
    if progress && (step % 100 == 0)
      info("t: $(lpad(step, 9)) \t θ: $(round(temperature, 2)) \t Q: $(round(Q0, 3)) \t m: $(length(unique(values(m))))")
    end
  end
  EcologicalNetworks.tidy_modules!(m)
  return Y, m
end
