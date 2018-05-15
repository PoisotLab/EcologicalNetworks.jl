module TestBetaDivOperations
  using Base.Test
  using EcologicalNetwork

  A = UnipartiteNetwork(rand(Bool, (10, 10)))
  B = UnipartiteNetwork(rand(Bool, (10, 10)))
  U = union(A,B)
  I = intersect(A,B)
  @test typeof(U) == typeof(B)
  @test links(U) >= links(A)
  @test links(U) >= links(B)
  @test links(I) <= links(B)
  @test links(I) <= links(A)
  @test richness(I) == richness(B)

  A = BipartiteNetwork(rand(Bool, (10, 10)))
  B = BipartiteNetwork(rand(Bool, (20, 20)))
  U = union(A,B)
  I = intersect(A,B)
  @test typeof(U) == typeof(B)
  @test links(U) >= links(A)
  @test links(U) >= links(B)
  @test richness(U) == richness(B)
  @test links(I) <= links(B)
  @test links(I) <= links(A)
  @test richness(I) == richness(A)

  # No common species
  A = UnipartiteNetwork(eye(Bool, 3), [:a, :b, :c])
  B = UnipartiteNetwork(eye(Bool, 3), [:d, :e, :f])

  @test species(setdiff(B, A)) == species(B)
  @test species(setdiff(A, B)) == species(A)
  @test richness(intersect(A, B)) == 0
  @test links(intersect(A, B)) == 0

end
