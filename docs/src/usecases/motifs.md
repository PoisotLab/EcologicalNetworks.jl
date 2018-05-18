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
