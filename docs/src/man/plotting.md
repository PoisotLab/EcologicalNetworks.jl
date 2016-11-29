# Plotting

Plotting is done with the [`plot_network`](@ref) function.

~~~@repl
using EcologicalNetwork
N = bluthgen()
plot_network(N, file="bluthgenDegree.png")
~~~

This is what the result should look like:

![Bluthgen network, ordered by degree][bldg]

[bldg]: bluthgenDegree.png

## Plotting modular networks

Plotting modular networks is a special case, for which the `plot_network`
function accepts an additional argument (a network [`Partition`](@ref)).

## Additional information

~~~@docs
plot_network
~~~
