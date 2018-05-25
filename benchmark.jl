using Revise # To avoid reloading the session while we test things
include("./src/EcologicalNetwork.jl")
using EcologicalNetwork
using StatsBase
using NamedTuples
using Combinatorics

begin
    using JuliaDB
    using Base.Test
    using Distributions
    using Plots, StatPlots
end

# Important for benchmark
srand(2000)

ref_net = simplify(BipartiteNetwork(rand(Bool, (20,15))))
while richness(ref_net) != 35
    ref_net = simplify(BipartiteNetwork(rand(Bool, (20,15))))
end


fm(x) = find_motif(x, BipartiteNetwork([true true; true false]))
bench(N, f, i) = (@elapsed [f(N) for rep in 1:i])/i

function mkbench(n, i)
    return @NT(
        richness = richness(n),
        links = links(n),
        size = size(n),
        unipartite = typoef(n) <: AbstractUnipartiteNetwork,
        eta = bench(n, η, i),
        nodf = bench(n, nodf, i),
        spe = bench(n, specificity, i),
        lnk = bench(n, links, i),
        lp = bench(n, lp, i),
        int = bench(n, interactions, i),
        mot = bench(n, fm, i),
        nl2 = bench(n, null2, i),
        deg = bench(n, degree, i),
        con = bench(n, connectance, i)
    )
end

ref_measure = mkbench(ref_net, 2)

bench_test = web_of_life.(getfield.(filter(x -> x.Species <= 300, web_of_life()), :ID))
bench_test = convert.(BinaryNetwork, bench_test)

bench_results = NamedTuple[]
@progress for test_net in bench_test
    bench_measure = mkbench(test_net, 3)
    push!(bench_results, bench_measure)
end

bv = table(bench_results)
bv = pushcol(bv, :ld, select(bv, :links) ./ select(bv, :richness))
bv = pushcol(bv, :co, select(bv, :links) ./ prod.(select(bv, :size)))

fields = Dict(
    :eta => "eta",
    :nodf => "nodf",
    :mot => "motif enum",
    :nl2 => "null model II",
    :deg => "degree",
    :con => "connectance",
    :lnk => "links",
    :spe => "specificity",
    :lp => "label propagation",
    :int => "interactions enum"
    )

for (field, field_name) in fields
    p1 = @df bv scatter(:links, select(bv, field), zcolor=:richness, c=:viridis, legend=:bottomright, leg=false)
    p2 = @df bv scatter(:richness, select(bv, field), zcolor=:links, c=:viridis, legend=:bottomright, leg=false)
    p3 = @df bv scatter(:ld, select(bv, field), zcolor=:richness, c=:viridis, legend=:bottomright, leg=false)
    p4 = @df bv scatter(:co, select(bv, field), zcolor=:richness, c=:viridis, legend=:bottomright, leg=false)
    yaxis!(p1, "Time (s)", :log10)
    xaxis!(p1, "Links")
    yaxis!(p2, "Time (s)", :log10)
    xaxis!(p2, "Richness")
    yaxis!(p3, "Time (s)", :log10)
    xaxis!(p3, "Link density")
    yaxis!(p4, "Time (s)", :log10)
    xaxis!(p4, "Connectance")
    title!(p1, field_name)
    plot((p1,p2,p3,p4)..., size=(900,600))
    savefig("benchmark/pdf_"*string(field)*".pdf")
    savefig("benchmark/png_"*string(field)*".png")
end
