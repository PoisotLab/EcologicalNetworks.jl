# Motif enumeration

```@setup motif_uc
using EcologicalNetwork
using StatPlots
```

```@example motif_uc
```

N = simplify(first(nz_stream_foodweb()))

omnivory = unipartitemotifs()[:S2]

n0 = length(find_motif(N, omnivory))

sample_size = 100
nd = zeros(Int64, sample_size)
nf = zeros(Int64, sample_size)
Threads.@threads for i in 1:sample_size
    println(i)
    nd[i] = length(find_motif(shuffle(N; constraint=:degree), omnivory))
    nf[i] = length(find_motif(shuffle(N; constraint=:fill), omnivory))
end

density(n0.-nd, lab="Degree")
density!(n0.-nf, lab="Fill")

n_swaps = repeat(convert.(Int64, round.(10.^collect(0:0.1:6), 0)); inner=10)
n_omni = zeros(Int64, length(n_swaps))
for i in eachindex(n_swaps)
    R = shuffle(N; number_of_swaps=n_swaps[i])
    n_omni[i] = length(find_motif(R, omnivory))
end

z(x,y) = (x.-y)./std(x)

scatter(n_swaps, n_omni, c=:grey, leg=false, frame=:box, ms=0)
plot!([minimum(n_swaps), maximum(n_swaps)], [n0,n0], c=:black)
scatter!(n_swaps, n_omni, c=:lightgrey)
xaxis!(:log10, "Number of permutations")
yaxis!("Relative difference")
