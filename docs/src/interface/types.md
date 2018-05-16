# Types of networks

One feature of `EcologicalNetwork` which makes the rest of the package works is
the type system to represent networks. This is not the most enthralling reading,
but this pacge will walk you through the different options, and discuss how and
when to use them.

## Network representation

Network types are designed to be immutable -- no operations done by the package
will modify the original network. When needed, copies or new objects will be
returned.

**TODO**

At all points, you can have a look at the types of the interactions and the species objects:

```@docs
eltype
```

### Partiteness

### Type of information

## List of available types

```@docs
UnipartiteNetwork
BipartiteNetwork
UnipartiteQuantitativeNetwork
BipartiteQuantitativeNetwork
UnipartiteProbabilisticNetwork
BipartiteProbabilisticNetwork
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
