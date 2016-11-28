# Measuring the modularity

In this example, we will use [`label_propagation`](@ref) to optimize the
modularity of a network. The data are from the [`mcmullen`](@ref) dataset.

~~~@repl
using EcologicalNetwork

# Get the data in an object
N = mcmullen();

# We will start with a random assignment of species within modules
L = rand(1:richness(N), richness(N));

# We can now start a repeated number of attempts to find the best partition. If
# julia is started in parallel, this will use all assigned CPUs.
M = modularity(N, L, replicates=30)

~~~

