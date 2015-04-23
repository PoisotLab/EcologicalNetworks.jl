This page presents a number of use-cases, *i.e.* short examples of how the library can be used to perform real-world analyses.

# Number of links in a probabilistic network

Assuming there is a probabilistic interaction matrix `A`, one can be interested
in measuring the number of links of this matrix, and compare it to the binary
version, or to randomized networks.

This can be done in the following way:

``` julia
μL = links(A)
σL = links_var(A)
println("There are ", μL, "±", σL, " links")
```

The same can be done for the binary network:

``` julia
println("There are ", links(make_binary(A)), " non-zero interactions")
```

To generate Bernoulli networks, it is recommended to use the null-model wrapper:

``` julia
M = nullmodel(A)
L = map(links, M)
println("Randomized networks have ", mean(L), "±", var(L), "interactions")
```

# Number of paths

The `number_of_paths` function will return a matrix giving the *expected* number
of paths of a given length between all pairs of nodes. For example, the
following code will give the expected number of paths of length 3:

``` julia
A = [0.1 0.3; 1.0 0.0]
number_of_paths(A, n=3)
```
