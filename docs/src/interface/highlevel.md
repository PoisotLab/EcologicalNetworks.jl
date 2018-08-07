# Core functions

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

### Network slices

```@docs
getindex
```

### Random network samples

```@docs
sample
```

## Network utilities

### Network size

```@docs
size
```

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

### Modify interactions

```@docs
setindex!
```
