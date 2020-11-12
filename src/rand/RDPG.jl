"""
    RDPG(N::BinaryNetwork; rank::Integer=3)

Given a binary network `N`, `RDPG(N)` returns a probabilistic network with the
same number of species, where every interaction happens with a probability equal
to the dot product of species representation in the network `N`'s RDPG space of
rank `rank`.

Because the pairwise dot product obtained by the matrix multiplication of the
two spaces `Left * Right` are not granted to be bounded between 0 and 1 (for
numerical and theoric reasons), we bound the entries to be in the `[0,1]` range.


#### References

Dalla Riva, G.V. and Stouffer, D.B., 2016. Exploring the evolutionary signature
of food webs' backbones using functional traits. Oikos, 125(4), pp.446-456.
https://doi.org/10.1111/oik.02305

"""
function RDPG(N::T; rank::Integer=3) where {T<:BinaryNetwork}
  L, R = svd_truncated(N; rank=rank)
  ardpg = L * R
  ardp[ardpg .< 0.] .= 0.
  ardpg[ardpg .> 1.] .= 1.
  ReturnType = typeof(N) <: AbstractBipartiteNetwork ? BipartiteProbabilisticNetwork : UnipartiteProbabilisticNetwork
  return ReturnType(ardpg, EcologicalNetworks.species_objects(N)...)
end
