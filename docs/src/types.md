# Informations about types

As there are many ways to represent ecological networks, and the correct way to
measure a given property varies in function of the representation,
`EcologicalNetwork` has a series of built-in types.

## Type hierarchy

The `EcologicalNetwork` package has six main types that are meant to be used by
the user: `BipartiteNetwork`, `BipartiteProbaNetwork`, `BipartiteQuantiNetwork`,
`UnipartiteNetwork`, `UnipartiteProbaNetwork` and `UnipartiteQuantiNetwork`. All
types with `Proba` in their names are meant to represent probabilistic networks,
and are also part of the union type `ProbabilisticNetwork`. All types *without*
`Proba` in their name are part of the union type `DeterministicNetwork`, and
represent networks in which interactions are either present or absent. All types
with `Quanti` in their names are part of the `QuantitativeNetwork` groups, and
represent networks with weighted interactions. All types starting with
`Bipartite` are also part of the abstract type `Bipartite`, and types with
`Unipartite` in their names are part of the abstract type `Unipartite`. Finally,
both `Unipartite` and `Bipartite` are part of the abstract type `AbstractEcologicalNetwork`.

Although this may seem convoluted, this is important to understand: when writing
functions, you can restrict them to any type of network you want by using the
right type in their declaration. You can also check properties of a network just
by looking at its type. For example, one can check whether a network `N` is
bipartite with:

```julia
typeof(N) <: Bipartite
```

Networks are represented as two-dimensional matrices. All types are simply
wrappers around an adjacency matrix, stored as the `A` property of the object.
To look at the adjacency matrix of a network `N`, one therefore uses `N.A`.
These matrices must be read as: the existence/probability of an interaction
*from* the species of the *i*-th row *to* the species in the *j*-th column. This
implies that the networks are, by default, directed.

Note that the type of a network will determine what methods can be applied to
it. For example, all measures of variance are only making sense for
probabilistic networks.

## Data types

Interactions in deterministic networks are represented as boolean
(`true`/`false`) values. This is memory efficient, so large networks can be
represented (one interactions represented as a boolean uses 8 times fewer memory
than the same interaction represented as an integer). This being said, all
networks of the `DeterministicNetwork` type can be read from matrices of
integers, *as long as these matrices only contain 0 and 1*.

In probabilistic networks, interactions are stored as floating point (`Float64`)
numbers. These values have to be between 0.0 and 1.0, as they represent
probabilities. In quantitative networks, interactions are stored as any type of
number.

Networks of the `Unipartite` class must have the same number of rows and
columns. The species in the rows and columns are the same. Networks of the
`Bipartite` class are expected to have different numbers of rows and columns, as
the species in rows and columns are different species. It is possible to convert
a network from `Bipartite` to `Unipartite` using the `make_unipartite` function:

~~~@example
using EcologicalNetwork
B = BipartiteNetwork(rand(Bool, (3, 5)))
U = make_unipartite(B)
richness(U) == richness(B)
~~~

The documentation for `make_unipartite` gives additional explanations about how
the conversion is done. In the overwhelming majority of cases, applying any
measure to a bipartite network, and to the same network made unipartite, should
give the same results (connectance is one notable example).

## Type reference

~~~@autodocs
Modules = [EcologicalNetwork]
Order = [:type]
Pages = ["types.jl"]
~~~
