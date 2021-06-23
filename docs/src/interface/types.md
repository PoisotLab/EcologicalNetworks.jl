One feature of `EcologicalNetwork` which makes the rest of the package works is
the type system to represent networks. This is not the most enthralling reading,
but this pacge will walk you through the different options, and discuss how and
when to use them.

## Network representation

All networks types have a field `edges` to store the *sparse* adjacency matrix,
and fields `S`, or `T` and `B`, for species in unipartite and bipartite networks
respectively. `edges` is always a two-dimensional array (see below for more
information), where interactions go *from the rows*, *to the columns*. Network
types are **mutable**. Operations that will modify the network end with a `!`,
as is the julian convention.

Fields `S`, `T`, and `B` are one-dimensional arrays of `AllowedSpeciesTypes` --
they currently can be `String` or `Symbol`, and represent the species/nodes
names. Future allowed types will be added in later releases.

You should *never* have to manipulate the network by calling its fields
directly. The `species` function will give you access to the species, and the
network slicing operations (see later sections) will let you access subset of
the network / individual interactions / set of neighbours.

Network types are iterable: this is equivalent to calling the `interactions`
function on a network. On small networks, `interactions` is faster (but
allocates the whole memory at once). On large networks, it can be less true, and
using the iteration approach can save some time. The iteration protocol is the
same as for all other Julia collections:

~~~
for (int_number, interaction) in N
  @info "Interaction $(int_number) -- $(interaction)"
end
~~~

The objects returned by the iteration protocol are named tuples with fields `to`
and `from` (always), and can have additional fields `probability` and
`strength`.

### Partiteness

In unipartite networks, the adjacency matrix `edges` is square, and has as many
rows/columns as there are elements in `S`. This is always checked and enforced
upon construction of the object, so you *cannot* have a mismatch.

In bipartite networks, the matrix `edges` is not necessarily square, and has
dimensions equal to the lengths of `T` (rows) and `B` (columns). This too is
checked upon construction.

All elements in `S` *must* be unique (no duplicate node names). In addition, all
names in the union of `T` and `B` must be unique too (so that when a bipartite
network is cast to a unipartite one, the constraint on unique names in `S` is
respected). These constraints are enforced when constructing the object, and
will return explicit error messages if not met.

### Type of information

At all points, you can have a look at the types of the interactions and the
species objects -- the next entries in this documentation give additional
information about the types allowed.

```@docs
eltype
```

## Union types

All networks are grouped upon the `AbstractEcologicalNetwork` type:

```@docs
AbstractEcologicalNetwork
```

The type of nodes that are allowed is determined by the *non-exported*
`EcologicalNetworks._check_species_validity` function. To allow an additional type of
node, you can write the following:

~~~ julia

struct Foo
  name::AbstractString
  bar::AbstractFloat
end

import EcologicalNetworks
function EcologicalNetworks._check_species_validity(::Type{Foo})
end
~~~

Note that **integers are never valid species identifiers**. By default, `String`
and `Symbol` are used. The function `_check_species_validity` should do *nothing*
for an accepted type (and it will throw an error for any other type).

### By partiteness

```@docs
AbstractBipartiteNetwork
AbstractUnipartiteNetwork
```

### By interaction type

```@docs
BinaryNetwork
QuantitativeNetwork
ProbabilisticNetwork
DeterministicNetwork
```


## List of available types

These are the types that you *actually* declare and use. They are presented last
because it is easier to understand what they are when you get a sense for the
different union types.

```@docs
UnipartiteNetwork
BipartiteNetwork
UnipartiteQuantitativeNetwork
BipartiteQuantitativeNetwork
UnipartiteProbabilisticNetwork
BipartiteProbabilisticNetwork
```
