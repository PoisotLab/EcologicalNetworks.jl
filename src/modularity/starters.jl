"""
    n_random_modules(n::Int64)

This returns *a function* which, when applied to a network, will randomly assign
every species to one of `n` modules. The correct way to apply this function to a
network `N` is, therefore `n_random_modules(4)(N)` (with four modules).

#### References

Thébault, E., 2013. Identifying compartments in presence–absence matrices and
bipartite networks: insights into modularity measures. Journal of Biogeography
40, 759–768. https://doi.org/10.1111/jbi.12015
"""
function n_random_modules(n::Int64)
  n > 0 || throw(ArgumentError("The number of modules must be a positive integer, you used $(n)"))
  n_random = (N::AbstractEcologicalNetwork) -> (N, Dict([species(N)[i] => rand(1:n) for i in 1:richness(N)]))
  return n_random
end

"""
    each_species_its_module(N::T) where {T<:AbstractEcologicalNetwork}

Returns a dictionary in which each species is its own module. This is used as a
starting point for `lp` and `salp` internally. This is often a very poor
starting point for `brim`, and should probably not be used on its own.

#### References

Thébault, E., 2013. Identifying compartments in presence–absence matrices and
bipartite networks: insights into modularity measures. Journal of Biogeography
40, 759–768. https://doi.org/10.1111/jbi.12015
"""
function each_species_its_module(N::T) where {T<:AbstractEcologicalNetwork}
  L = Dict([species(N)[i]=>i for i in 1:richness(N)])
  return (N, L)
end
