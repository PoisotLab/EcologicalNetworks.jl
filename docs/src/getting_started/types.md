# The type system

The package relies on a compreensive system of types to represent networks. The
purpose of the type system is to ensure that data are represented without
ambiguities, but also to specialize the algorithm applied to each type of
network.

The networks are represented as *sparse* matrices, for performance reasons. In
practice, networks are standard Julia arrays, in that they can be accessed by
position, sliced, have a `size` and `axes`, *etc.*.

```@docs
SpeciesInteractionNetwork
```

## Representing species

```@docs
SpeciesInteractionNetworks.Partiteness
Bipartite
Unipartite
```

## Representing interactions

```@docs
SpeciesInteractionNetworks.Interactions
Binary
Quantitative
Probabilistic
```
