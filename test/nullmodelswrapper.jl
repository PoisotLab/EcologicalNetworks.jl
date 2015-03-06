module TestNullModelsWrapper
  using Base.Test
  using ProbaNet

  # Generate some data

  A = [0.0 0.0 0.0; 0.0 1.0 0.0; 0.0 0.0 1.0]

  B = nullmodel(A, n=10, max=10)

  @test length(B) == 0

end
