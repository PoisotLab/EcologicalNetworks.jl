module TestBetaDivOperations
  using Base.Test
  using EcologicalNetwork

  A = UnipartiteNetwork(rand(Bool, (10, 10)))
  B = UnipartiteNetwork(rand(Bool, (10, 10)))
  U = union(A,B)
  I = intersect(A,B)
  @assert typeof(U) == typeof(B)
  @assert links(U) >= links(A)
  @assert links(U) >= links(B)
  @assert links(I) <= links(B)
  @assert links(I) <= links(A)
  @assert richness(I) == richness(B)

  A = BipartiteNetwork(rand(Bool, (10, 10)))
  B = BipartiteNetwork(rand(Bool, (20, 20)))
  U = union(A,B)
  I = intersect(A,B)
  @assert typeof(U) == typeof(B)
  @assert links(U) >= links(A)
  @assert links(U) >= links(B)
  @assert richness(U) == richness(B)
  @assert links(I) <= links(B)
  @assert links(I) <= links(A)
  @assert richness(I) == richness(B)

  # TODO no setdiff
  # TODO only unique species

end
