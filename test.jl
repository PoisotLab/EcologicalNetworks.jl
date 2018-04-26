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

@elapsed trials = [Q(lpbrim(N)...) for i in 1:1000]

Threads.nthreads()

a = zeros(3000)
chunks = 1000
length(a)/chunks
@elapsed Threads.@threads for i in 1:convert(Int64, length(a)/chunks)
    i_start = (i-1)*chunks+1
    i_end = i_start + chunks - 1
    a[i_start:i_end] = [Q(lpbrim(N)...) for j in 1:chunks]
end

Threads.@threads for i in 1:200
    rand()*rand()
    println(i)
end
