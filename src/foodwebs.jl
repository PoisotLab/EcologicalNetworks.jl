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
  while has_updated
    has_updated = false
    preys_of_rank_i = (Y.A * (TL .== current_i))
    if sum(preys_of_rank_i) > 0
      has_updated = true
      TL[positions(preys_of_rank_i .> 0)] = current_i + 1
      current_i = current_i + 1
    end
  end

  return TL

end
