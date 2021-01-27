# Modularity

The analysis of network modularity is done in three steps:

1. generate a starting point, using one of the starter functions
2. optimize modularity
3. analyse the output

All starter functions take a network as input, and return a tuple of this
network and a dictionary where every species maps onto its module. This forms
the input of all other modularity related functions.

## Measures

```@docs
Q
Qr
```

## Starters

```@docs
n_random_modules
each_species_its_module
lp
```

## Optimizers

```@docs
brim
salp
leadingeigenvector
```

## Functional roles

```@docs
functional_cartography
```
