module TestMotifs
using Base.Test
using EcologicalNetwork

@test unipartitemotifs()[:S1].A == [false true false; false false true; false false false];

n = UnipartiteNetwork(zeros(Bool, (2, 2)))
m = unipartitemotifs()[:S1]
@test motif(n, m) ≈ 0.0

# Test with a single link
N = UnipartiteProbabilisticNetwork([0.2 0.8; 0.2 0.1])
m = UnipartiteNetwork([false true; false false])
b = zeros(Float64, size(m))
o = zeros(Float64, prod(size(m)))
EcologicalNetwork.motif_internal!(N, m, b, o)
@test o == vec([0.8 0.8 0.8 0.9])

# Test with a perfect match
N = UnipartiteProbabilisticNetwork([0.0 1.0; 0.0 0.0])
m = UnipartiteNetwork([false true; false false])
b = zeros(Float64, size(m))
o = zeros(Float64, prod(size(m)))
EcologicalNetwork.motif_internal!(N, m, b, o)
@test o == vec([1.0 1.0 1.0 1.0])
@test motif_p(N, m, b, o) == 1.0
@test motif_v(N, m, b, o) == 0.0

# Test with a fork-like thing
diam = UnipartiteNetwork([0 1 0 0; 0 0 1 1; 0 0 0 0; 0 0 0 0].>0)
clin = UnipartiteNetwork([0 1 0; 0 0 1; 0 0 0].>0)
capp = UnipartiteNetwork([0 1 1; 0 0 0; 0 0 0].>0)
cdir = UnipartiteNetwork([0 0 1; 0 0 1; 0 0 0].>0)

@test motif(diam, clin) ≈ 2.0
@test motif(diam, capp) ≈ 1.0
@test motif(diam, cdir) ≈ 0.0

# Test with a diamond food web
diam = UnipartiteNetwork([0 1 1 0; 0 0 0 1; 0 0 0 1; 0 0 0 0].>0)
clin = UnipartiteNetwork([0 1 0; 0 0 1; 0 0 0].>0)
capp = UnipartiteNetwork([0 1 1; 0 0 0; 0 0 0].>0)
cdir = UnipartiteNetwork([0 0 1; 0 0 1; 0 0 0].>0)

@test motif(diam, clin) ≈ 2.0
@test motif(diam, capp) ≈ 1.0
@test motif(diam, cdir) ≈ 1.0

lfc = UnipartiteNetwork([0 1 0; 0 0 1; 0 0 0].>0)
wsl = UnipartiteNetwork([1 1 0; 0 0 1; 0 0 0].>0)

@test motif(wsl, lfc) ≈ 1.0

lfc = UnipartiteNetwork([0 1 0; 0 0 1; 0 0 0].>0)
wsl = UnipartiteQuantiNetwork([1 0.5 0; 0 0 1.6; 0 0 0])

@test motif(wsl, lfc) ≈ 1.0

# Test with a diamond food web
diam = BipartiteNetwork([1 1 0; 1 1 1].>0)
tthr = BipartiteNetwork([1 0; 1 1].>0)
tfou = BipartiteNetwork([1 1; 1 1].>0)

@test motif(diam, tthr) ≈ 2.0
@test motif(diam, tfou) ≈ 1.0

# Test on a three-species network
B = UnipartiteNetwork([false true true; false false true; false false false])
@test motif(B, B) == 1.0

BDN = BipartiteNetwork([false true true; false false true; false false false])
@test motif(BDN, BDN) == 1.0

# Test on the same network, this time with a proba one
P = UnipartiteProbabilisticNetwork([0.0 1.0 1.0; 0.0 0.0 1.0; 0.0 0.0 0.0])
B = UnipartiteNetwork([false true true; false false true; false false false])
@test motif_var(P, B) == 0.0

# Test with some variation
ovl = UnipartiteNetwork([false true true; false false true; false false false])
N = UnipartiteProbabilisticNetwork([0.0 1.0 0.8; 0.0 0.0 1.0; 0.0 0.0 0.0])
@test motif(N, ovl) ≈ 0.8
fchain = UnipartiteNetwork([false true false; false false true; false false false])
@test motif(N, fchain) ≈ 0.2

# Test of the simplest situation: two nodes, ten random matrices
for i in 1:10
    N = BipartiteProbabilisticNetwork(rand((2, 2)))
    possible_motifs = (
    [0 1; 0 0], [1 0; 0 0], [0 0; 1 0], [0 0; 0 1],
    [1 1; 0 0], [1 0; 0 1], [1 0; 1 0],
    [0 1; 1 0], [0 1; 0 1],
    [0 0; 1 1],
    [0 1; 1 1], [1 0; 1 1], [1 1; 1 0], [1 1; 0 1],
    [0 0; 0 0], [1 1; 1 1]
    )
    b = zeros(Float64, size(N))
    o = zeros(Float64, prod(size(N)))
    all_probas = map((x) -> motif_p(N, BipartiteNetwork(map(Bool, x)), b, o), possible_motifs)
    @test sum(all_probas) ≈ 1.0
end

end
