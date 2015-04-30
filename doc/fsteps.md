# Loading the package

Simply use

``` julia
using ProbabilisticNetwork
```

Depending on your version of `julia`, there may be a few warnings (especially if
you use the *nightlies* version). This is not an issue, since these are only
deprecation warning when syntax for the *stable* is still supported, but
deprecated. When `julia` moves to 0.4 as the current release, these will be
fixed accordingly.

# Documentation

The package comes with full documentation, so typing `?functionname` will
display its docstring. For example, `?centrality_katz` returns

```
help?> centrality_katz
search: centrality_katz

centrality_katz (generic function with 1 method)

[method]

ProbabilisticNetwork.centrality_katz(A::Array{Float64, 2})

  Measures Katz's centrality for each node in a unipartite network.

  Keyword arguments

  - a (def. 0.1), the weight of each subsequent connection
  - k (def. 5), the maximal path length considered

 Details:
  source: (10,"~/.julia/v0.4/ProbabilisticNetwork/src/./centrality.jl")
```

To get a list of all functions, you can either type `ProbabilisticNetwork.` and
press Tab, or have a look at the automated [documentation file](api.md).

# Overview and coding conventions

The `ProbabilisticNetwork` package provides a series of functions to manipulate
probabilistic (ecological) networks, and measure their structure. As much as
possible, functions are named after the name of the measure they implement:
`connectance` measures connectance. When an analytical expression of variance
can be measured, the function is suffixed with `_var`. For example,
`connectance_var` is the variance of connectance.

All functions in the module take as their first argument a matrix **A**, whose
elements are all floating point numbers between 0 and 1. The type of **A** is
*always* `A::Array{Float64, 2}` (a two-dimensional array of floats). If
required, additional arguments are given as *keyword arguments*.
