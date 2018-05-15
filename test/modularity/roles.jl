
# Functional roles

A = [
     false true false false false false;
     false false false true false false;
     false true false false false false;
     false false false false true false;
     false false false false false true;
     false false false false false false
    ]
U = UnipartiteNetwork(A)
L = [1,1,1,2,2,2]
P = Partition(U, L)
n = networkroles(P)

# Values of z
@test n[1,1] ≈ -0.57 atol = 0.02
@test n[2,1] ≈  1.15 atol = 0.02
@test n[3,1] ≈ -0.57 atol = 0.02
@test n[4,1] ≈ -0.57 atol = 0.02
@test n[5,1] ≈  1.15 atol = 0.02
@test n[6,1] ≈ -0.57 atol = 0.02

# Values of c
@test n[1,2] ≈ 0.00 atol = 0.02
@test n[2,2] ≈ 0.45 atol = 0.02
@test n[3,2] ≈ 0.00 atol = 0.02
@test n[4,2] ≈ 0.50 atol = 0.02
@test n[5,2] ≈ 0.00 atol = 0.02
@test n[6,2] ≈ 0.00 atol = 0.02
