"""
    null1(N::BinaryNetwork)

Given a matrix `A`, `null1(A)` returns a matrix with the same dimensions,
where every interaction happens with a probability equal to the connectance of
`A`.
"""
function null1(N::BinaryNetwork)
    itype = typeof(N) <: AbstractBipartiteNetwork ? BipartiteProbabilisticNetwork : UnipartiteProbabilisticNetwork
    return itype(fill(connectance(N), size(N)), species_objects(N)...)
end

"""
    null3out(N::BinaryNetwork)

Given a matrix `A`, `null3out(A)` returns a matrix with the same dimensions,
where every interaction happens with a probability equal to the out-degree
(number of successors) of each species, divided by the total number of possible
successors.
"""
function null3out(N::BinaryNetwork)
  return permutedims(null3in(permutedims(N)))
end

"""
    null3in(N::BinaryNetwork)

Given a matrix `A`, `null3in(A)` returns a matrix with the same dimensions,
where every interaction happens with a probability equal to the in-degree
(number of predecessors) of each species, divided by the total number of
possible predecessors.
"""
function null3in(N::BinaryNetwork)
  itype = typeof(N) <: AbstractBipartiteNetwork ? BipartiteProbabilisticNetwork : UnipartiteProbabilisticNetwork
  A = N.A
  proba = sum(A; dims=1)./size(A,1)
  imat = repeat(proba, size(A,1))
  return itype(imat, species_objects(N)...)
end

"""
    null2(N::BinaryNetwork)

Given a matrix `A`, `null2(A)` returns a matrix with the same dimensions, where
every interaction happens with a probability equal to the degree of each
species.
"""
function null2(N::BinaryNetwork)
  itype = typeof(N) <: AbstractBipartiteNetwork ? BipartiteProbabilisticNetwork : UnipartiteProbabilisticNetwork
  A = N.A
  pr1 = sum(A; dims=2)./size(A,2)
  pr2 = sum(A; dims=1)./size(A,1)
  imat = (pr1.+pr2)./2.0
  return itype(imat, species_objects(N)...)
end
