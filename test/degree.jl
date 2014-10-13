module TestDegreeFunctions
   using Base.Test
   using PEN
   
   # Generate some data

   A = [[0.22 0.4], [0.3 0.1]]

   d_in = vec([0.52 0.5])
   d_out = vec([0.62 0.4])
   d_tot = vec([1.14 0.9])

   Din = degree_in(A)
   Dout = degree_out(A)
   Dtot = degree(A)

   for i in 1:2
      @test_approx_eq d_in[i] Din[i]
      @test_approx_eq d_out[i] Dout[i]
      @test_approx_eq d_tot[i] Dtot[i]
   end
   
end
