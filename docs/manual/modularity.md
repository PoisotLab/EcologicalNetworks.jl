---
title : Modularity
author : Timothée Poisot
date : 11th April 2018
layout: default
---




There are two steps to modularity analysis. First, we assign a module *a priori*
to all species in the network. Second, we optimize this partition using
heuristics. We will illustrate how these functions work by simulating a reasonably modular network:

````julia
A = zeros(Bool, (12,12))
A[1:6,1:6] = rand(Float64, (6,6)).<0.8
A[7:12,7:12] = rand(Float64, (6,6)).<0.8
B = simplify(BipartiteNetwork(A))
````





## Initial modules assignation

Modules are stored as a dictionary with one integer value for each species in
the network. One way to have each species start in its own module is, for
example, to do

````julia
L = Dict([species(B)[i] => i for i in 1:richness(B)])
L
````


````
Dict{String,Int64} with 24 entries:
  "t3"  => 3
  "t7"  => 7
  "b12" => 24
  "b2"  => 14
  "t10" => 10
  "t5"  => 5
  "b8"  => 20
  "b11" => 23
  "t4"  => 4
  "b7"  => 19
  "b9"  => 21
  "t12" => 12
  "b3"  => 15
  "t2"  => 2
  "t11" => 11
  "t1"  => 1
  "t8"  => 8
  "b5"  => 17
  "b10" => 22
  ⋮     => ⋮
````





The functions to perform the initial modules assignation must return a tuple
with the network in the first position, and the dictionary of modules in the
second position.

### Random modules

One current way to proceed is to guesstimate the number of modules, and assign
species to them at random. This can be done with the `n_random_modules`
function:

````julia
five_rand = n_random_modules(5)
````


<pre class="julia-error">
ERROR: UndefVarError: N not defined
</pre>


````julia
five_rand(B)[2]
````


<pre class="julia-error">
ERROR: UndefVarError: five_rand not defined
</pre>




Note that `n_random_modules` *returns* a function which will create `n` modules
at random.

### Label propagation

`EcologicalNetwork` offers a `lp` function for label propagation @TODO -- while
most adapted for large graphs, we found that LP usually gives a robust starting
partition regardless of the size.

````julia
initial_p = lp(B)
initial_p[2]
````


````
Dict{String,Int64} with 24 entries:
  "t3"  => 5
  "t7"  => 10
  "b12" => 10
  "b2"  => 1
  "t10" => 6
  "t5"  => 2
  "b8"  => 7
  "b11" => 9
  "t4"  => 5
  "b7"  => 10
  "b9"  => 10
  "t12" => 10
  "b3"  => 1
  "t2"  => 3
  "t11" => 8
  "t1"  => 4
  "t8"  => 7
  "b5"  => 4
  "b10" => 6
  ⋮     => ⋮
````





## Modularity optimization

Functions to optimize the modularity accept two arguments: a network, and a
dictionary with modules identity. You may recognize this as the output of the
functions to initially assign modules, and you would be right. This allows
unpacking the output of the initial module assignation function into the
modularity function, following the template of

```
modularity(initial(network)...)
```

### BRIM

````julia
b_brim = brim(lp(B)...)
````





## Modularity functions
