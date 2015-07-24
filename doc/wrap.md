There are, currently, two wrappers. The first is used to generate random
Bernoulli networks. The second is used to optimize modularity. Both are highly
experimental and should probably not be trusted too much.

# Null models

The `nullmodel` wrapper allows to rapidly generate Bernoulli trials given a
probability matrix. If `julia` is working on several cores (`julia -p 10` for 10
cores), the replications will be done in parallel.

This function will return *only* networks in which every species has a degree of
*at least* one. For this reason,

1. The number of replicates to run to get a large enough sample size may be large
2. The resulting sample may be biased -- this is a problem we are currently solving, but that is shared by all random matrices generators

The `nullmodel` wrapper takes two keyword arguments, `n` and `max`, that are
respectively the number of networks to generate, and the maximal number of
trials. If the number of suitable samples is *less* than `n`, the wrapper will
issue a warning.

Calling the wrapper is done with:

``` julia
# Read a 0/1 matrix
interactions = readdlm("int.dat")

# Transform into a template probability matrix using null model 2
A = null2(interactions)

# Start the wrapper
M = nullmodel(A, n=1000, max=10000)

# Print the average nestedness
nest = map(x -> nestedness(x)[1], M)
```

# Modularity

*Coming soon*.
