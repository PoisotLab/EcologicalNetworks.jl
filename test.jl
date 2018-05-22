include("./src/EcologicalNetwork.jl")
using EcologicalNetwork
using StatsBase

begin
    using Base.Test
    using Distributions
    using Plots, StatPlots
end

N = simplify(first(nz_stream_foodweb()))

omnivory = unipartitemotifs()[:S2]
foodchain = unipartitemotifs()[:S1]

omni0 = length(find_motif(N, omnivory))
chain0 = length(find_motif(N, foodchain))
loop0 = length(find_motif(N, loop))

swap_increment = 100
n_increments = 300
n_omni = zeros(Int64, n_increments)
n_chain = zeros(Int64, n_increments)
n_loop = zeros(Int64, n_increments)
R = copy(N)
@progress for i in 1:n_increments
    R = shuffle(R; number_of_swaps=swap_increment)
    n_omni[i] = length(find_motif(R, omnivory))
    n_chain[i] = length(find_motif(R, foodchain))
end

z(x,y) = (x.-y)./std(x)

n_swaps = collect(1:n_increments).*swap_increment

scatter(n_swaps, z(n_omni, omni0), c=:grey, leg=false, frame=:origin)
scatter!(n_swaps, z(n_chain, chain0), c=:red, leg=false)
