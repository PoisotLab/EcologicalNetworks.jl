"""
    linearfilter(N::BinaryNetwork, α::Vector{Float64}=[0.25, 0.25, 0.25, 0.25])

Given a network `N` compute the linear filter scores according to Stock et al.
(2017). High scores for negative interactions indicate potential false negative
or missing interactions. Though this it returned as a probabilistic network,
score do not necessary convey a probabilistic interpretation.
"""
function linearfilter(N::T; α::Vector{Float64}=fill(0.25, 4)) where {T <: BinaryNetwork}
  @assert length(α) == 4
  @assert all(α .≥ 0.0)
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
  for i in 1:richness(N; dims=1)
    s1 = species(N; dims=1)[i]
    for j in 1:richness(N; dims=2)
      s2 = species(N; dims=2)[j]
      t_val = α[1]*N[i,j] + (α[2]/m)*k_out[s1] + (α[3]/n)*k_in[s2] + α[4]/(n*m)*A
      F[s1,s2] = max(min(t_val, 1.0), 0.0)
    end
  end

  return F
end

"""
    linearfilterzoo(N::BinaryNetwork, α::Vector{Float64}=[0.25, 0.25, 0.25, 0.25])

Compute the zero-one-out version of the linear filter (`linearfilter`), i.e.
the score for each interaction if that interaction would not occur in the network.
For example, if N[4, 6] = 1 (interaction between species 4 and 6), the result at
postion (4, 6) is the score of the filter using a network in which that interaction
did not occur. This function is useful for validating the filter whether it can
detect false negative (missing) interactions.
"""
function linearfilterzoo(N::T; α::Vector{Float64}=fill(0.25, 4)) where {T <: BinaryNetwork}
  F = linearfilter(N, α=α)  # depart from scores of the filter
  Fzoo = F  # update the values to zero-one-out scores, reference is to keep
            # the code readable

  # Get the size of the network
  n = richness(N; dims=1)
  m = richness(N; dims=2)
  # Get probabilities
  for s1 in species(N; dims=1)
    for s2 in species(N; dims=2)
      t_val = F[s1,s2] - (α[1] + (α[2]/m) + (α[3]/n) + α[4]/(n * m)) * N[s1,s2]
      Fzoo[s1,s2] = max(min(t_val, 1.0), 0.0)
    end
  end

  return Fzoo
end
