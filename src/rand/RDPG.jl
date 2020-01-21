"""
    RDPG(N::BinaryNetwork; rank::Integer=3)
Given a matrix `A`, `RDPG(A)` returns a matrix with the same dimensions, where
every interaction happens with a probability equal to the dot product of species representation in their RDPG space of dimension `rank`.

Because the elements `Â = Left * Right` are not granted to be bounded between 0 and 1, we truncate the entries in the `[0,1]` range. 

#### References

Dalla Riva, G.V. and Stouffer, D.B., 2016. Exploring the evolutionary signature of food webs' backbones using functional traits. Oikos, 125(4), pp.446-456. https://doi.org/10.1111/oik.02305

"""
function RDPG(N::BinaryNetwork; rank::Integer=3)
  L, R = svd_truncated(N, rank)
  Ardpg = L * R
  Ardpg[Ardpg .< 0.] .= 0.
  Ardpg[Ardpg .> 1.] .= 1.
  ReturnType = typeof(N) <: AbstractBipartiteNetwork ? BipartiteProbabilisticNetwork : UnipartiteProbabilisticNetwork
  return ReturnType(Ardpg, EcologicalNetworks.species_objects(N)...)
end
