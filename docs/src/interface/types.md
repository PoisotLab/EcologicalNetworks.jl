# Types of networks

One feature of `EcologicalNetwork` which makes the rest of the package works is
the type system to represent networks. This is not the most enthralling reading,
but this pacge will walk you through the different options, and discuss how and
when to use them.

## Network representation

All networks types have a field `A` to store the adjacency matrix, and fields
`S`, or `T` and `B`, for species in unipartite and bipartite networks
respectively. `A` is always a two-dimensional array (see below for more
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
function on a network. On small networks, `interactions` is faster. On large
networks, it can be less true, and using the iteration approach can save some
time. The iteration protocol is the same as for all other Julia collections:

~~~
for (int_number, interaction) in N
  @info "Interaction $(int_number) -- $(interaction)"
end
~~~

The objects returned by the iteration protocol are named tuples with fields `to`
and `from` (always), and can have additional fields `probability` and
`strength`.

### Partiteness

In unipartite networks, the adjancency matrix `A` is square, and has as many
rows/columns as there are elements in `S`. This is always checked and enforced
upon construction of the object, so you *cannot* have a mismatch.

In bipartite networks, the matrix `A` is not necessarily square, and has
dimensions equal to the lengths of `T` (rows) and `B` (columns). This too is
checked upon construction.

All elements in `S` *must* be unique (no duplicate node names). In addition, all
names in the union of `T` and `B` must be unique too (so that when a bipartite
network is cast to a unipartite one, the constraint on unique names in `S` is
respected).

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

All allowed types for nodes are part of the `AllowedSpeciesTypes` type:

```@docs
AllowedSpeciesTypes
```

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
