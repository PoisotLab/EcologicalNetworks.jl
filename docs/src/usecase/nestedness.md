# Measuring the nestedness of a network

The goal of this use case is to (i) measure the nestedness of a bipartite
network and (ii) evaluate whether it differs from the random expectation.

We will use the [`ollerton`](@ref) data, which are reasonably small:

~~~@repl
using EcologicalNetwork

# Get the data in an object
N = ollerton()
~~~

