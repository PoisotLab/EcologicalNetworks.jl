module TestSpectralRadius
using Test
using EcologicalNetworks

# All examples are from Figure 1 of SK&A 2013

A = [1 1 1 1; 1 1 1 1; 1 1 1 0; 1 1 0 0; 1 1 0 0; 1 1 0 0]
N = BipartiteNetwork(A.>0)
@test ρ(N; range=EcologicalNetworks.ρ_raw) ≈ 3.82 atol = 0.01

A = [0 1 1 1; 1 0 1 1; 1 1 0 1; 1 1 1 0; 1 1 1 0; 1 0 0 1]
N = BipartiteNetwork(A.>0)
@test ρ(N; range=EcologicalNetworks.ρ_raw) ≈ 3.515 atol = 0.01

A = [1 1 1 1; 1 1 1 0; 1 1 1 0; 1 1 1 0; 1 1 1 0; 1 0 0 0]
N = BipartiteNetwork(A.>0)
@test ρ(N; range=EcologicalNetworks.ρ_raw) ≈ 3.944 atol = 0.01

A = [1 0 1 1; 1 1 0 1; 1 1 1 0; 1 1 1 0; 1 1 1 0; 0 1 0 1]
N = BipartiteNetwork(A.>0)
@test ρ(N; range=EcologicalNetworks.ρ_raw) ≈ 3.595 atol = 0.01

# This specific example was added to catch a bug due to the wrong
# normalization, see issue #203

A = [1 1 1 1; 1 1 1 0; 1 1 1 0; 1 1 1 0; 1 1 1 0; 1 0 0 0]
N = BipartiteNetwork(A.>0)
@test ρ(N, range=EcologicalNetworks.ρ_raw) ≈ 3.943904 atol = 0.01
@test ρ(N, range=EcologicalNetworks.ρ_ska) ≈ 0.956537 atol = 0.01

end
