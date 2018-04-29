---
title : Network β-diversity
author : Timothée Poisot
date : 11th April 2018
layout: default
---




In this case study, we will compare the species composition and interaction
composition of a collection of networks:

````julia
Tr = map(n -> convert(BinaryNetwork, n), trojelsgaard_et_al_2014())
````


<pre class="julia-error">
ERROR: UndefVarError: trojelsgaard_et_al_2014 not defined
</pre>




## Is there strong global β-diversity?

For this first question, we will compare each network to its relevant part in
the metaweb -- this offers a way to measure how different each *measured*
network is compared to what we would expect knowing all regional interactions.

````julia
metaweb = reduce(union, Tr)
````


<pre class="julia-error">
ERROR: UndefVarError: Tr not defined
</pre>




The function to measure the difference between interactions between shared
species is `βos`: we can apply it to an array of network using the `.` syntax.

We can pipe the output all the way to a plot:

````julia
os_prime = βos.(Tr, metaweb) .|> whittaker
````


<pre class="julia-error">
ERROR: UndefVarError: Tr not defined
</pre>


````julia
scatter(sort(os_prime), xlab="Sites", ylab="Dissimilarity", c=:black, leg=false)
````


<pre class="julia-error">
ERROR: UndefVarError: os_prime not defined
</pre>




This analysis reveals that most networks are reasonably close to what we expect
at the regional scale. We can identify the *most* dissimilar network:

````julia
most_dissimilar = first(find(os_prime .== maximum(os_prime)))
````


<pre class="julia-error">
ERROR: UndefVarError: os_prime not defined
</pre>


````julia
Tr[most_dissimilar]
````


<pre class="julia-error">
ERROR: UndefVarError: Tr not defined
</pre>




## Pairwise comparison between networks

In the next step, we will compare the dissimilarity of interactions with the
dissimilarity of species compositions:

````julia
Ds = zeros(Float64, (length(Tr), length(Tr)))
````


<pre class="julia-error">
ERROR: UndefVarError: Tr not defined
</pre>


````julia
Di = zeros(Float64, (length(Tr), length(Tr)))
````


<pre class="julia-error">
ERROR: UndefVarError: Tr not defined
</pre>


````julia
Dw = zeros(Float64, (length(Tr), length(Tr)))
````


<pre class="julia-error">
ERROR: UndefVarError: Tr not defined
</pre>


````julia
for i in eachindex(Tr[1:(end-1)])
  for j in (i+1):length(Tr)
    Ds[i,j] = sorensen(βs(Tr[i], Tr[j]))
    Di[i,j] = sorensen(βos(Tr[i], Tr[j]))
    Dw[i,j] = sorensen(βwn(Tr[i], Tr[j]))
  end
end
````


<pre class="julia-error">
ERROR: UndefVarError: Tr not defined
</pre>




We can represent this, with white points showing `βos` (interactions between
shared species), and black points showing `βwn` (total interactions):

````julia
pl = scatter(Ds, Di, leg=false, mc=:white, xlab="Species dissimilarity",
  ms=4, aspectratio=1, framestyle=:zerolines, ylab="Network dissimilarity")
````


<pre class="julia-error">
ERROR: UndefVarError: Ds not defined
</pre>


````julia
scatter!(pl, Ds, Dw, mc=:black, ms=4)
````


<pre class="julia-error">
ERROR: UndefVarError: pl not defined
</pre>


````julia
pl
````


<pre class="julia-error">
ERROR: UndefVarError: pl not defined
</pre>




This illustrate a common result: the similarity of species composition is not a
good predictor of the fact that these species will interact in the same way!
