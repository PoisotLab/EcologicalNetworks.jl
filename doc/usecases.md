This page presents a number of use-cases, *i.e.* short examples of how the
library can be used to perform real-world analyses.

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

# Network β-diversity

The package currently implements the following measures of pairwise network
dissimilarity: `jaccard`, `sorensen`, `gaston`, `williams`, `lande`, `ruggiero`,
`hartekinzig`, `harrison`, and `whittaker`. The common approach to measure the
dissimilarity of two networks is first, after Koleff et al. (2004; JAE), to
measure the dissimilarity set, then to feed it into any of the pairwise
dissimilarity functions.

Note that for this analysis to make sense, the two matrices *must* have the
species at the same positions in rows and columns.

``` julia
# Dummy test with equal matrices
A = eye(10)
B = eye(10)
S = betadiversity(A, B)
println("Whittaker: ", whittaker(S)) # Should give 0.0, the networks are similar

# Test with real data
A = [1.0 0.3 0.0; 0.2 0.8 1.0; 0.2 0.4 0.3]
B = [1.0 0.8 0.2; 0.4 0.6 0.7; 0.1 0.7 0.6]
S = betadiversity(A, B)
jaccard(S) # Should give approx. 0.471
```

# Modularity

This library implements two measures of modularity. The one given by Barber
(`Q`), which compares the linkage across modules to a null model based on degree
(basically, `null2`), and the *realized* modularity (`Qr`), which is simply the
expected proportion of the expected number of links that are within the same
modules. Note than when there is a single module, `Qr` and `Q` are *by default*
equal to 0.

The modularity functions work on a type called `Partition`, which has three
attributes: `A` is the probability matrix, `L` is an array of (`Int64`) module
IDs, and `Q` is Barber's modularity of the partition.

# Motif enumeration

Motifs can be specified by their adjacency matrix. For example, an omnivory loop
(A eats B and C, B eats C), is

``` julia
ovl = [0.0 1.0 1.0; 0.0 0.0 1.0; 0.0 0.0 0.0]
```

We can then count how many times this motif appears within itself:

``` julia
motif(ovl, ovl) # This will return 1
```

If we design a simple network in which A eats C only 80% of the time, we can
compare the number of times we expect to see an omnivory loop as opposed to a
single linear food chain:

``` julia
A = [0.0 1.0 0.8; 0.0 0.0 1.0; 0.0 0.0 0.0]
motif(A, ovl) # This will return 0.8
fchain = [0.0 1.0 0.0; 0.0 0.0 1.0; 0.0 0.0 0.0]
motif(A, fchain) # This will return 0.2
```
