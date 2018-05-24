include("./src/EcologicalNetwork.jl")
using EcologicalNetwork
using StatsBase
using NamedTuples
using Combinatorics

begin
    using Base.Test
    using Distributions
    using Plots, StatPlots
end

N = simplify(first(nz_stream_foodweb()))

function internal_shuffle(S::BinaryNetwork, f)
    collection = [typeof(S)(reshape(shuffle(vec(S.A)), size(S)), species(S)) for i in 1:1000]
    for c in collection
        if (f(c) == f(S))&(c.A != S.A)&(links(c)==links(nodiagonal(c)))
            return c
        end
    end
    info("hyuck")
    return S
end

Y = copy(N)

@time begin
    S = sample(Y, 3)
    while isdegenerate(S)
        S = sample(Y, 3)
    end
    repl = internal_shuffle(S, degree_in)
    p1 = indexin(species(repl,1), species(Y,1))
    p2 = indexin(species(repl,2), species(Y,2))
    Y.A[p1,p2] = repl.A
end

heatmap(N.A .- Y.A, aspectratio=1)

degree_in(Y) == degree_in(N)
