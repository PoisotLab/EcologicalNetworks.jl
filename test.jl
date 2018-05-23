include("./src/EcologicalNetwork.jl")
using EcologicalNetwork
using StatsBase
using NamedTuples

begin
    using Base.Test
    using Distributions
    using Plots, StatPlots
end

N = simplify(first(nz_stream_foodweb()))
Y = copy(N)

@time Y = shuffle(Y)

n = interactions(N)
a = Array{last(eltype(N))}(length(n),2)
for i in eachindex(n)
    a[i,1] = n[i].from
    a[i,2] = n[i].to
end
todo = true
while todo
    a[:,1] = shuffle(a[:,1])
    todo = length(unique(a[:,1].*a[:,2])) != links(N)
end

A = zeros(Bool, size(N))
for i in 1:size(a,1)
    from, to = a[i,:]
    i1, i2 = findfirst(species(N,1), from), findfirst(species(N,2), to)
    A[i1,i2] = true
end

sum(A)
links(N)
