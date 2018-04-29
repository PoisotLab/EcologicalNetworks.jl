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
````


<pre class="julia-error">
ERROR: UndefVarError: fonseca_ganade_1996 not defined
</pre>


````julia
nodf(N)
````


<pre class="julia-error">
ERROR: UndefVarError: N not defined
</pre>




## Binary networks

````julia
M = convert(BinaryNetwork, N)
````


<pre class="julia-error">
ERROR: UndefVarError: N not defined
</pre>


````julia
nodf(N)
````


<pre class="julia-error">
ERROR: UndefVarError: N not defined
</pre>


````julia
η(M)
````


<pre class="julia-error">
ERROR: UndefVarError: M not defined
</pre>




## Probabilistic networks

````julia
T = null2(M)
````


<pre class="julia-error">
ERROR: UndefVarError: M not defined
</pre>


````julia
η(T)
````


<pre class="julia-error">
ERROR: UndefVarError: T not defined
</pre>

