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
N = fonseca_ganade_1996()
nodf(N)
````


````
Dict{Symbol,Float64} with 3 entries:
  :rows    => 0.1075
  :network => 0.0880952
  :columns => 0.0395833
````





## Binary networks

````julia
M = convert(BinaryNetwork, N)
nodf(N)
````


````
Dict{Symbol,Float64} with 3 entries:
  :rows    => 0.1075
  :network => 0.0880952
  :columns => 0.0395833
````



````julia
η(M)
````


````
Dict{Symbol,Float64} with 3 entries:
  :rows    => 0.187648
  :network => 0.168149
  :columns => 0.148649
````





## Probabilistic networks

````julia
T = null2(M)
η(T)
````


````
Dict{Symbol,Float64} with 3 entries:
  :rows    => 0.174305
  :network => 0.178413
  :columns => 0.182521
````


