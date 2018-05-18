"""
    n_random_modules(n::Int64)

This returns *a function* which, when applied to a network, will randomly assign
every species to one of `n` modules.
"""
function n_random_modules(n::Int64)
  @assert n > 0
  n_random = (N::AbstractBipartiteNetwork) -> (N, Dict([species(N)[i] => rand(1:n) for i in 1:richness(N)]))
  return n_random
end

"""
    each_species_its_module(N::T) where {T<:AbstractEcologicalNetwork}

Returns a dictionary in which each species is its own module. This is used as a
starting point for `lp` internally.
"""
function each_species_its_module(N::T) where {T<:AbstractEcologicalNetwork}
  L = Dict([species(N)[i]=>i for i in 1:richness(N)])
  return (N, L)
end
