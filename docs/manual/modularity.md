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
A = zeros(Bool, (8,8))
A[1:4,1:4] = rand(Float64, (4,4)).<0.8
A[5:8,5:8] = rand(Float64, (4,4)).<0.8
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
Dict{String,Int64} with 16 entries:
  "t3" => 3
  "t7" => 7
  "b2" => 10
  "t5" => 5
  "b8" => 16
  "t4" => 4
  "b7" => 15
  "b3" => 11
  "t2" => 2
  "t1" => 1
  "t8" => 8
  "b5" => 13
  "t6" => 6
  "b4" => 12
  "b6" => 14
  "b1" => 9
````





The functions to perform the initial modules assignation must return a tuple
with the network in the first position, and the dictionary of modules in the
second position. For example, we can create a function to assign the species to
5 random modules with:

````julia
function random_modules(;n::Int64=5)
  return (N::BinaryNetwork) -> (N, Dict([species(N)[i] => rand(1:n) for i in 1:richness(N)]))
end

five_rand = random_modules(n=5)
five_rand(B)[2]
````


````
Dict{String,Int64} with 16 entries:
  "t3" => 5
  "t7" => 1
  "b2" => 2
  "t5" => 2
  "b8" => 3
  "t4" => 5
  "b7" => 5
  "b3" => 3
  "t2" => 5
  "t1" => 5
  "t8" => 4
  "b5" => 5
  "t6" => 5
  "b4" => 5
  "b6" => 5
  "b1" => 5
````





`EcologicalNetwork` offers a `lp` function for label propagation @TODO -- while
most adapted for large graphs, we found that LP usually gives a robust starting
partition regardless of the size.

````julia
initial_p = lp(B)
initial_p[2]
````


````
Dict{String,Int64} with 16 entries:
  "t3" => 2
  "t7" => 3
  "b2" => 2
  "t5" => 5
  "b8" => 5
  "t4" => 2
  "b7" => 3
  "b3" => 2
  "t2" => 2
  "t1" => 1
  "t8" => 4
  "b5" => 3
  "t6" => 3
  "b4" => 2
  "b6" => 3
  "b1" => 1
````





## Modularity optimization

## Modularity functions
