# Network β-diversity

Measures of β-diversity work by first calculating the unique/shared items (using
the `βs`, `βos`, and `βwn` functions), then passing on these arguments to one of
the `KGLXX` functions to return a (dis)similarity score. The `KGL` functions are
named for Koleff, Gaston, and Lennon -- the number of each function matches the
number in Table 1.

## β-diversity components

The package implements functions for the βs, βos, and βwn components of network
dissimilarity. In the original publication, we also described βst, which was the
proprotion of dissimilarity due to species turnover, and defined as βst = βwn -
βos *for measures of dissimilarity bounded between 0 and 1*. After discussing
with colleagues and considering our own use-cases, it appears that the
interpretation of βst is not always straightforward, and so we have decided to
exclude it form the available functions.

```@docs
βs
βos
βwn
```

One measure which is possibly missing is a function to build the metaweb, *i.e.*
aggregate all species and interactions in a collection of networks. This can be
done using `union`, *e.g.*

~~~julia
N = nz_stream_foodweb() # Or any collection of networks
metaweb = reduce(union, N)
~~~

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
