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

## Additional information

~~~@docs
plot_network
~~~
