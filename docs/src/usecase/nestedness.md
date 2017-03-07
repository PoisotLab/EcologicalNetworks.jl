# Measuring the nestedness of a network

The goal of this use case is to (i) measure the nestedness of a bipartite
network and (ii) evaluate whether it differs from the random expectation. We
will use the [`ollerton`](@ref) data, which are reasonably small, and the
[`η`](@ref) measure of nestedness (note that [`nodf`](@ref) is also available).

~~~@example
using EcologicalNetwork

# Get the data in an object
N = ollerton();

# We will create a function to return the nestedness of the entire
# network instead of an array of nestedness values
nest = (x) -> η(x)[1]

# We will now generate a series of random networks preserving the degree
# distribution
S = nullmodel(null2(N));

# There is a function to apply a test rapidly to randomized networks. In this
# situation we are interested in testing the fact that the network is more
# nested than expected by chance.
results = test_network_property(N, nest, S,
        test=:greater);

# We can print the results
println(
        "The original network has a nestedness of ",
        round(nest(N), 3),
        ",\n", "which is greater than expected by chance (p ~ ",
        round(results.pval, 4),
        ") -- ",
        results.n,
        " random networks."
        )
~~~

In this simple example, we used [`nullmodel`](@ref) to generate random
realizations of a network, and [`test_network_property`](@ref) to evaluate
whether the observed nestedness was observed by chance. As it stands, all
randomized networks had *lower* values, and so the *p*-value is (essentially)
null. In short, this network is significantly more nested than expected by
chance knowing its degree distribution.

We can also decide to plot the network to visualize what it looks like:

~~~@repl
using EcologicalNetwork
N = ollerton()
plot_network(N, file="ollerton.png")
~~~

This is what the result should look like:

![ollerton plot][ollertonplot]

[ollertonplot]: ollerton.png
