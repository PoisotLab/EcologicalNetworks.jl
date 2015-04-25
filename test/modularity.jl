module TestModularity
  using Base.Test
  using ProbabilisticNetwork

  # Example network 1
  A = [0.0 1.0 1.0 0.0 0.0 0.0;
  1.0 0.0 1.0 0.0 0.0 0.0;
  1.0 1.0 0.0 0.0 0.0 0.0;
  0.0 0.0 0.0 0.0 1.0 1.0;
  0.0 0.0 0.0 1.0 0.0 1.0;
  0.0 0.0 0.0 1.0 1.0 0.0;]

  mod = modularity(A)
  @test_approx_eq mod.Q 0.375
  @test length(unique(mod.L)) == 2
  @test mod.L[1] == mod.L[2]
  @test mod.L[3] != mod.L[4]
  @test mod.Q == Q(mod.A, mod.L)

  # Example network 2
  A = [0.0 1.0 1.0 0.0 0.2 0.0;
  1.0 0.0 1.0 0.0 0.0 0.0;
  1.0 1.0 0.0 0.0 0.0 0.0;
  0.0 0.0 0.0 0.0 1.0 1.0;
  0.0 0.1 0.0 1.0 0.0 1.0;
  0.3 0.0 0.0 1.0 1.0 0.0;]

  mod = modularity(A)
  @test mod.Q < 0.375

  # Example network 3
  A = eye(Float64, 5)

  mod = modularity(A)
  @test mod.L[1] == 1
  @test mod.L[2] == 2
  @test mod.L[3] == 3
  @test_approx_eq Qr(mod) 1.0
  @test_approx_eq Q(mod) mod.Q

  # Example network 4
  A = eye(Float64, 3)
  @test_approx_eq modularity(A).Q 15/36

  # Tests with a single module
  A = eye(2)
  mod = modularity(A)
  mod.L = vec([1 1])
  @test Qr(mod) == 0.0

  # Test with a complete graph
  A = ones(Float64, (3, 3))
  mod = modularity(A)
  @test length(unique(mod.L)) == 1
  @test_approx_eq mod.Q 0.25000000000000006
  @test Qr(mod) == 0.0

end
