# Network β-diversity

Measures of β-diversity work by first calculating the unique/shared items (using
the `βs`, `βos`, and `βwn` functions), then passing on these arguments to one of
the `KGLXX` functions to return a (dis)similarity score. The `KGL` functions are
named for Koleff, Gaston, and Lennon -- the number of each function matches the
number in Table 1.

## β-diversity components

```@docs
βs
βos
βwn
```

## β-diversity measures

```@docs
KGL01
```

## Basic operations on networks

Internally, the functions for β-diversity rely on the usual operations on sets.
The act of combining two networks, for example, is a `union` operation.

```@docs
setdiff
union
intersect
```
