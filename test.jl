include("./src/EcologicalNetwork.jl")
using EcologicalNetwork

using Plots
plotly()

A = zeros(Bool, (12,12))
A[1:4,1:4] = rand(Bool, (4,4))
A[5:8,5:8] = rand(Bool, (4,4))
A[9:12,9:12] = rand(Bool, (4,4))

B = simplify(BipartiteNetwork(A))

N = convert(BinaryNetwork, fonseca_ganade_1996())

lpbrim = (n) -> n |> lp |> x -> brim(x...)

@elapsed trials = [lpbrim(N) for i in 1:1000]
plot(sort(trials .|> x -> Q(x...)))

Threads.nthreads()

a = zeros(1000)
@elapsed Threads.@threads for i in eachindex(a)
  a[i] = Q(lpbrim(N)...)
end

a
