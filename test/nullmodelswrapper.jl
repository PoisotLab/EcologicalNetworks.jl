module TestNullModelsWrapper
  using Base.Test
  using EcologicalNetwork

  # Test 1 -- model with one free species = no output
  A = [0.0 0.0 0.0; 0.0 1.0 0.0; 0.0 0.0 1.0]
  B = nullmodel(A, n=10, max=10)
  @test length(B) == 0

  # Test 2 -- full graph converges
  A = [1.0 1.0; 1.0 1.0]
  B = nullmodel(A, n=10, max=10)
  @test length(B) == 10

  # Test 3 -- works if max < n
  A = [1.0 1.0; 1.0 1.0]
  B = nullmodel(A, n=5, max=2)
  @test length(B) == 5

end
