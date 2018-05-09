function n_random_modules(n::Int64)
  @assert n > 0
  n_random = (N::AbstractBipartiteNetwork) -> (N, Dict([species(N)[i] => rand(1:n) for i in 1:richness(N)]))
  return n_random
end

function each_species_its_module{T<:AbstractEcologicalNetwork}(N::T)
  L = Dict([species(N)[i]=>i for i in 1:richness(N)])
  return (N, L)
end
