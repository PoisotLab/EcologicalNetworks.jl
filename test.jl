include("./src/EcologicalNetwork.jl")
using EcologicalNetwork

A = zeros(Bool, (12,12))
A[1:4,1:4] = rand(Bool, (4,4))
A[5:8,5:8] = rand(Bool, (4,4))
A[9:12,9:12] = rand(Bool, (4,4))

B = simplify(BipartiteNetwork(A))

N = mccullen_1993()
L = lp(N)[2]
EcologicalNetwork.tidy_modules!(L)
L

@assert all(species(N) .∈ keys(L))

old_Q = Q(N, L)
new_Q = old_Q+0.00001

m = links(N)

c = length(unique(collect(values(L))))

R = zeros(Int64, (richness(N,1),c))
for si in eachindex(species(N,1))
  R[si,L[species(N,1)[si]]] = 1
end

T = zeros(Int64, (richness(N,2),c))
for sj in eachindex(species(N,2))
  T[sj,L[species(N,2)[sj]]] = 1
end

B = N.A .- null2(N).A

while old_Q < new_Q

  t_tilde = B*T
  R = map(Int64, t_tilde .== maximum(t_tilde, 2))
  r_tilde = B'*R
  T = map(Int64, r_tilde .== maximum(r_tilde, 2))
  S = vcat(R, T)
  L = Dict(zip(species(N), vec(mapslices(r -> StatsBase.sample(find(r)), S, 2))))
  EcologicalNetwork.tidy_modules!(L)
  L
  old_Q = new_Q
  new_Q = Q(N,L)

end

Q(N,L)
Qr(N,L)
