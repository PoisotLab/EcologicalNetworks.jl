# Measuring the nestedness of a network

The goal of this use case is to (i) measure the nestedness of a bipartite
network and (ii) evaluate whether it differs from the random expectation. We
will use the [`ollerton`](@ref) data, which are reasonably small, and the
[`η`](@ref) measure of nestedness.

~~~@repl
using EcologicalNetwork

# Get the data in an object
N = ollerton();

richness(N)

# We will create a function to return the nestedness of the entire
# network instead of an array of nestedness values
nest = (x) -> η(x)[1]

# The nestedness of the network is...
nest(N)

# Now that this is done, we can generate a few random networks with the same
# degree distribution as the original one
S = nullmodel(null2(N), n=1000, max=2000)
~~~

