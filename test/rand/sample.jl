module TestNullModels
  using Base.Test
  using EcologicalNetwork

  # Generate some data

  A = [true true false; true true true; false true false]
  N = UnipartiteNetwork(A)

  @test size(sample(N), 2) = (2,2)
  @test size(sample(N), (2,2)) = (2,2)
  @test size(sample(N), (2,)) = (2,2)

  A = [true true false; true true true; false true false]
  N = BipartiteNetwork(A)

  @test size(sample(N), 2) = (2,2)
  @test size(sample(N), (2,)) = (2,2)
  @test size(sample(N), (2,1)) = (2,1)


end
