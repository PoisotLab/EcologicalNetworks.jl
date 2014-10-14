module TestNestedness
   using Base.Test
   using PEN
   
   # Generate some data

   A = [[1.0 0.0 0.0], [0.0 0.1 0.0], [0.0 0.0 0.1]]
   B = [[1.0 1.0 1.0], [1.0 0.1 0.0], [1.0 0.0 0.0]]

   @test_approx_eq nestedness(A)[1] 0.0
   @test_approx_eq nestedness(B)[1] 1.0
   
end
