function δ{T<:AbstractEcologicalNetwork,E<:AllowedSpeciesTypes}(N::T, L::Dict{E,Int64})
    @assert all(species(N) .∈ keys(L))
    this_l = filter((k,v) -> k in species(N), L)
    tl = [this_l[s] for s in species(N,1)]
    bl = [this_l[s] for s in species(N,2)]
    D = tl .== bl'
    return D
end

function Q{T<:AbstractEcologicalNetwork,E<:AllowedSpeciesTypes}(N::T, L::Dict{E,Int64})
  @assert all(species(N) .∈ keys(L))

  # Degrees
  dkin, dkout = degree_in(N), degree_out(N)
  kin = map(x -> dkin[x], species(N,2))
  kout = map(x -> dkout[x], species(N,1))

  # Value of m -- sum of weights, total number of int, ...
  m = links(N)

  # Null model
  kikj = (kout .* kin')
  Pij = kikj ./ m

  # Difference
  diff = N.A .- Pij

  # Diff × delta
  dd = diff .* δ(N,L)

  return sum(dd)/m
end

function Qr{T<:AbstractEcologicalNetwork,E<:AllowedSpeciesTypes}(N::T, L::Dict{E,Int64})
  @assert all(species(N) .∈ keys(L))
  W = sum(N.A .* δ(N, L))
  B = links(N)
  return 2.0 * (W/B) - 1.0
end

function tidy_modules!{E<:AllowedSpeciesTypes}(L::Dict{E,Int64})
  l_values = sort(unique(collect(values(L))))
  for i in 1:length(l_values)
    for (k,v) in L
      if v == l_values[i]
        L[k] = i
      end
    end
  end
end
