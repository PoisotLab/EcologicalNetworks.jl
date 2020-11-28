This page presents the core functions to manipulate networks. Whenever possible,
the approach of `EcologicalNetworks` is to overload functions from `Base`.

## Accessing species

```@docs
species
```

## Accessing interactions

### Presence of an interaction

```@docs
has_interaction
interactions
```
### Random network samples

```@docs
sample
```

## Network utilities

### Species richness

```@docs
richness
```

### Changing network shape

```@docs
permutedims
nodiagonal
nodiagonal!
```

### Invert interactions

```@docs
Base.:!
```

