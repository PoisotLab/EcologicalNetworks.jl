# Measuring the modularity

In this example, we will use [`label_propagation`](@ref) to optimize the
modularity of a network. The data are from the [`mcmullen`](@ref) dataset.

~~~@example modularity
using EcologicalNetwork

# Get the data in an object
N = mcmullen();
~~~

The next step is to generate starting communities for every species. We will
assign species to random initial modules:

~~~@example modularity
L = rand(1:richness(N), richness(N));
~~~

We can now start a repeated number of attempts to find the best partition, here
using [`label_propagation`](@ref). If `julia` is started in parallel, this will
use all assigned CPUs.

~~~@example modularity
M = modularity(N, L, label_propagation, replicates=100);

# Finally, we can get the best partition
b_part = best_partition(M);

# And print its modularity and number of modules
println("Q: ",
        round(b_part[1].Q, 2),
        " |c|: ",
        length(unique(b_part[1].L))
        )
~~~
