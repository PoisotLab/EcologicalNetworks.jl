---
title : Measuring nestedness
author : Timothée Poisot
date : 11th April 2018
layout: default
slug: nestedness
---




There are two measures of nestedness available: NODF [@AlmGui08], and η,
suggested as a variant less reliant or species ordering [@BasFor09]. Both of
these measures work for binary networks; NODF also works for quantitative
networks [@AlmUlr11a], and η for probabilistic networks [@PoiCir16].

There is no clear guideline about which measure to select [@DelBes17]: NODF is
sensitive to species ordering in the network, but η is entirely determined by
the degree distribution of the network -- this means that if your goal is to
perform significance testing using network permutations (instead of
randomizations), all networks will have the same value of η.

All measures return a dictionary with three values: the nestedness of the rows,
the nestedness of the columns, and the nestedness of the entire network.

## Quantitative networks

````julia
N = web_of_life("M_PA_003")
nodf(N)
````


````
Dict{Symbol,Float64} with 3 entries:
  :rows    => 0.0857143
  :network => 0.114392
  :columns => 0.125302
````





## Binary networks

````julia
M = convert(BinaryNetwork, N)
nodf(N)
````


````
Dict{Symbol,Float64} with 3 entries:
  :rows    => 0.0857143
  :network => 0.114392
  :columns => 0.125302
````



````julia
η(M)
````


````
Dict{Symbol,Float64} with 3 entries:
  :rows    => 0.15544
  :network => 0.176927
  :columns => 0.198413
````





## Probabilistic networks

````julia
T = null2(M)
η(T)
````


````
Dict{Symbol,Float64} with 3 entries:
  :rows    => 0.163263
  :network => 0.161702
  :columns => 0.160141
````


