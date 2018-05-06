include("./src/EcologicalNetwork.jl")
using EcologicalNetwork



N = simplify(nodiagonal(nz_stream_foodweb()[1]))
l = foodweb_layout(N; steps=100)
l = foodweb_layout(l...; steps=100)
graph_network_plot(l...; names=false)


```julia
z = (x,μ,σ) -> (x-μ)/σ
logistic = (x) -> 1/(1+exp(-x))
```


```julia
function motif_correction(N,M)
  mc = find_motif(N,M)
  pc = find_motif(null2(N),M)
  ec = expected_motif_count(pc)
  x = length(mc)
  μ, mvar = ec
  return logistic(z(x, μ, sqrt(mvar)))*2.0-1.0
end
```


```julia
pl = plot([0],[0], leg=false, framestyle=:origin);
xaxis!(pl, (0.5, 13.5))
yaxis!(pl, (-1.1, 1.1))
hline!(pl, [0.0], lab="", c=:black, ls=:dot)
hline!(pl, [-0.5,0.5], lab="", c=:black, ls=:dash)
cols = Colors.distinguishable_colors(length(NZ))
for i in eachindex(NZ)
  println(i)
  mo = sort(collect(keys(unipartitemotifs())))
  x = collect(1:length(mo))
  xmo = [unipartitemotifs()[m] for m in mo]
  y = motif_correction.(NZ[i], xmo)
  tco = cols[i]
  plot!(pl, x, y, lab="", c=:grey, lw=1)
  scatter!(pl, x, y, lab="", m=:circle, c=tco, lw=2)
  display(pl)
end
pl
```
