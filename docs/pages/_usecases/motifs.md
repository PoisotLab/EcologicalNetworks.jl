---
title : Motif counting in food webs
author : Timothée Poisot
date : 11th April 2018
layout: default
---




In this use case, we will enumerate unipartite motifs in 
18 food webs.

````julia
NZ = nz_stream_foodweb();
````



````julia
z = (x,μ,σ) -> (x-μ)/σ
logistic = (x) -> 1/(1+exp(-x))
````



````julia
function motif_correction(N,M)
  mc = find_motif(N,M)
  pc = find_motif(null1(N),M)
  ec = expected_motif_count(pc)
  x = length(mc)
  μ, mvar = ec
  return logistic(z(x, μ, sqrt(mvar)))
end
````


````
motif_correction (generic function with 1 method)
````



````julia
pl = plot(0,0, leg=false, framestyle=:grid)
for i in eachindex(NZ)
  scatter!(pl, [i], [motif_correction(NZ[i],unipartitemotifs()[:S4])], c=:red, m=:triangle)
  scatter!(pl, [i], [motif_correction(NZ[i],unipartitemotifs()[:S5])], c=:red, m=:circle)
end
xaxis!(pl, (1, length(NZ)))
yaxis!(pl, (0, 1))
hline!(pl, [0.5])
````


<pre class="julia-error">
ERROR: UndefRefError: access to undefined reference
</pre>

