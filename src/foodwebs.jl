"""
Returns the positions in an Array of boolean that are `true`.
"""
function positions(bool::Array{Bool, 1})
  return filter(x -> bool[x], 1:length(bool))
end

"""
Fractional trophic level as defined by Pauly & Palomares.

This function takes a unipartite network, either deterministic or quantitative,
as its input. There is currently no trophic rank formulation for probabilistic
networks.

The primary producers have a rank of 1, and species consuming any species of
maximal level $n$ have level $n+1$.

Note that the trophic level is measured on the network with self-interactions
removed.

```jldoctest
julia> stony() |> fractional_trophic_level |> maximum
5.0

julia> stony() |> fractional_trophic_level |> minimum
1.0
```
"""
function fractional_trophic_level(N::Union{UnipartiteNetwork, UnipartiteQuantiNetwork})
  Y = nodiag(N)
  TL = zeros(Float64, richness(Y))

  # producers
  TL[positions(degree_out(Y).==0)] = 1

  has_updated = true
  current_i = 1

  # This loop will go through increasing values of TL, and see if there is a
  # species that consumes a species with the current TL value. If so, then it
  # increases the maximum TL and starts again.
  while has_updated
    has_updated = false
    preys_of_rank_i = (Y.A * (TL .== current_i))
    if sum(preys_of_rank_i) > 0
      has_updated = true
      TL[positions(preys_of_rank_i .> 0)] = current_i + 1
      current_i = current_i + 1
    end
  end

  # return
  return TL
end

"""
Trophic level as defined by Pauly & Palomares.

This function weighs the fractional trophic level as returned by
`fractional_trophic_level` by the proportion of the prey in the predator's diet.
Specifically, this is done with:

$\text{TL}_i = 1 + \sum_{j \in \text{preys}} \left(\mathbf{f}_j\times\mathbf{D}_{ij}\right)$

The $\mathbf{j}$ array has the fractional trophic levels, and $\mathbf{D}$ is
the matrix with diet proportions. $\mathbf{D}_{ij}$ is $0.0$ for all
non-consumed preys. In a quantitative network, it is
$\mathbf{A}_{ij}/\sum\mathbf{A}_{i\dot}$, and it is the same in deterministic
networks although it works out to $1 / k_{o}(i)$ in the end.

As for `fractional_trophic_level`, this function is applied to the network
without self-edges.
"""
function trophic_level(N::Union{UnipartiteNetwork, UnipartiteQuantiNetwork})
  TL = fractional_trophic_level(N)
  Y = nodiag(N)
  D = zeros(Float64, Y.A)
  ko = degree_out(Y)

  # inner loop to avoid dealing with primary producers
  for i in 1:richness(Y)
    if ko[i] > 0.0
      D[i,:] = Y[i,:]./ko[i]
    end
  end

  # return
  return 1 .+ (D * TL)
end
