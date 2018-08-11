function linearfilter(N::T; α::Vector{Float64}=fill(0.25, 4)) where {T <: BinaryNetwork}
  @assert length(α) == 4
  α = α./sum(α) # This ensures that α sums to 1.0

  # Get the size of the network
  n = richness(N; dims=1)
  m = richness(N; dims=2)

  # Get the in and out degree, as well as the total number of interactions
  k_out = degree(N; dims=1)
  k_in = degree(N; dims=2)
  A = links(N)

  # Prepare a return object
  return_type = T <: AbstractBipartiteNetwork ? BipartiteProbabilisticNetwork : UnipartiteProbabilisticNetwork
  F = return_type(
    zeros(Float64, size(N)),
    EcologicalNetworks.species_objects(N)...
  )

  # Get probabilities
  for s1 in species(N; dims=1)
    for s2 in species(N; dims=2)
      F[s1,s2] = α[1]*N[s1,s2] + (α[2]/m)*k_out[s1] + (α[3]/n)*k_in[s2] + α[4]/(n*m)*A
    end
  end

  return F
end

"""
    null1(N::BinaryNetwork)

Given a matrix `A`, `null1(A)` returns a matrix with the same dimensions,
where every interaction happens with a probability equal to the connectance of
`A`.
"""
function null1(N::BinaryNetwork)
    return linearfilter(N; α=[0.0, 0.0, 0.0, 1.0])
end

"""
    null3out(N::BinaryNetwork)

Given a matrix `A`, `null3out(A)` returns a matrix with the same dimensions,
where every interaction happens with a probability equal to the out-degree
(number of successors) of each species, divided by the total number of possible
successors.
"""
function null3out(N::BinaryNetwork)
  return linearfilter(N; α=[0.0, 1.0, 0.0, 0.0])
end

"""
    null3in(N::BinaryNetwork)

Given a matrix `A`, `null3in(A)` returns a matrix with the same dimensions,
where every interaction happens with a probability equal to the in-degree
(number of predecessors) of each species, divided by the total number of
possible predecessors.
"""
function null3in(N::BinaryNetwork)
  return linearfilter(N; α=[0.0, 0.0, 1.0, 0.0])
end

"""
    null2(N::BinaryNetwork)

Given a matrix `A`, `null2(A)` returns a matrix with the same dimensions, where
every interaction happens with a probability equal to the degree of each
species.
"""
function null2(N::BinaryNetwork)
  return linearfilter(N; α=[0.0, 0.5, 0.5, 0.0])
end
