module TestNullModels
   using Base.Test
   using ProbaNet

   # Generate some data

   A = [[1.0 1.0 0.0], [1.0 1.0 1.0], [0.0 1.0 0.0]]

   n1 = null1(A)
   n2 = null2(A)
   n3o = null3out(A)
   n3i = null3in(A)

   # Null model 1
   @test_approx_eq n1[1,1] 6.0 / 9.0
   @test_approx_eq n1[2,2] 6.0 / 9.0
   @test_approx_eq n1[3,3] 6.0 / 9.0

end
