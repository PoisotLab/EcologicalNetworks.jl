include("./src/EcologicalNetwork.jl")
using EcologicalNetwork

using Plots
plotlyjs()

A = zeros(Bool, (12,12))
A[1:4,1:4] = rand(Bool, (4,4))
A[5:8,5:8] = rand(Bool, (4,4))
A[9:12,9:12] = rand(Bool, (4,4))

B = simplify(BipartiteNetwork(A))

N = convert(BinaryNetwork, fonseca_ganade_1996())

lpbrim = (n) -> n |> lp |> x -> brim(x...)
eabrim = (n) -> n |> each_species_its_module |> x -> brim(x...)
rndbrim = (n,c) -> n |> n_random_modules(c) |> x -> brim(x...)

lpruns = [lpbrim(N) for i in 1:500]
lp_c = lpruns .|> x -> collect(values(x[2])) |> unique |> length
lp_q = lpruns .|> x -> Q(x...)

c = rand(1:maximum(size(N)), 500)
e_runs = [rndbrim(N,i) for i in c]
e_c = e_runs .|> x -> collect(values(x[2])) |> unique |> length
e_q = e_runs .|> x -> Q(x...)

earuns = [eabrim(N) for i in 1:500]
lp_c = lpruns .|> x -> collect(values(x[2])) |> unique |> length
lp_q = lpruns .|> x -> Q(x...)

scatter(e_c, e_q, ms=4, c=:grey, msc=:grey)
scatter!(lp_c, lp_q, ms=2, c=:black)

maximum(e_q)
maximum(lp_q)
