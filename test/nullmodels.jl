module TestNullModels
  using Base.Test
  using ProbaNet

  # Generate some data

  A = [1.0 1.0 0.0; 1.0 1.0 1.0; 0.0 1.0 0.0]

  n1 = null1(A)
  n2 = null2(A)
  n3o = null3out(A)
  n3i = null3in(A)

  # Null model 1
  @test_approx_eq n1[1,1] 6.0 / 9.0
  @test_approx_eq n1[2,2] 6.0 / 9.0
  @test_approx_eq n1[3,3] 6.0 / 9.0

  # Null model 2
  @test_approx_eq n2[1,3] 0.5
  @test_approx_eq n2[2,2] 1.0
  @test_approx_eq n2[1,1] 2.0 / 3.0

  # Null model 3
  @test_approx_eq n3o[1,1] 2.0 / 3.0
  @test_approx_eq n3o[2,1] 1.0
  @test_approx_eq n3o[3,3] 1.0 / 3.0

  @test_approx_eq n3i[1,1] 2.0 / 3.0
  @test_approx_eq n3i[2,2] 1.0
  @test_approx_eq n3i[3,3] 1.0 / 3.0

end
