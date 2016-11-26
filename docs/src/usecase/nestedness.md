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
function nest(x)
    return η(x)[1]
end

# The nestedness of the network is...
nest(N)

# Now that this is done, we can generate a few random networks with the same
# degree distribution as the original one
S = nullmodel(null2(N), n=1000, max=2000);

# There is a functionm to apply a test rapidly to all randomized networks
results = test_network_property(N, nest, S, test=:greater);

# We can look at the p-value of the test
results.pval

# Or the z-scores
minimum(results.z)
median(results.z)
maximum(results.z)
~~~

In this simple example, we used [`nullmodel`](@ref) to generate random
realizations of a network, and [`test_network_property`](@ref) to evaluate
whether the observed nestedness was observed by chance. As it stands, all
randomized networks had *lower* values, and so the *p*-value is (essentially)
0. In short, this network is significantly more nested than expected by
chance knowing its degree distribution.
