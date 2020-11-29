"""
    show(io::IO, N::AbstractEcologicalNetwork)
"""
function Base.show(io::IO, N::AbstractEcologicalNetwork)
  p = typeof(N) <: AbstractBipartiteNetwork ? "bipartite" : "unipartite"
  t = ""
  t = typeof(N) <: ProbabilisticNetwork ? " probabilistic" : t
  t = typeof(N) <: QuantitativeNetwork ? " quantitative" : t
  print(io, "$(richness(N; dims=1))×$(richness(N; dims=2)) $(p)$(t) ecological network $(eltype(N)) (L: $(links(N)))")
end

"""
Creates a copy of a network -- this returns an object with the same type, and
the same content.
"""
function Base.copy(N::AbstractEcologicalNetwork)
  edges = copy(N.edges)
  sp = copy.(_species_objects(N))
  return typeof(N)(edges, sp...)
end

"""
    Base.:!{T<:DeterministicNetwork}(N::T)

Returns the inverse of a binary network -- interactions that were `false` become
`true`, and conversely.
"""
function Base.:!(N::T) where {T <: BinaryNetwork}
  return typeof(N)(dropzeros(.!N.edges), _species_objects(N)...)
end

"""
    permutedims(N::AbstractBipartiteNetwork)

Tranposes the network and returns a copy
"""
function Base.permutedims(N::AbstractEcologicalNetwork)
  NA = permutedims(N.edges)
  new_sp = typeof(N) <: AbstractBipartiteNetwork ? (N.B, N.T) : (N.S,)
  return typeof(N)(NA, new_sp...)
end

"""
    +(n1::T, n2::T) where {T <: BipartiteQuantitativeNetwork}

Adds two quantitative bipartite networks. TODO
"""
function Base.:+(n1::T, n2::T) where {T <: BipartiteQuantitativeNetwork}
  st = union(species(n1; dims=1), species(n2; dims=1))
  sb = union(species(n1; dims=2), species(n2; dims=2))
  A = zeros(_interaction_type(n1), (length(st), length(sb)))
  N = T(A, st, sb)
  for i1 in n1
    N[i1.from,i1.to] = N[i1.from,i1.to] + i1.strength
  end
  for i2 in n2
    N[i2.from,i2.to] = N[i2.from,i2.to] + i2.strength
  end
  return N
end
