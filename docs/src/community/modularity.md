# Modularity

There are a number of modularity-related functions in `EcologicalNetworks`. The
optimal modularity structure is detected by optimizing $Q$, which returns values
increasingly close to unity when the modular structure is strong. The $Q_r$
measure is also included for *a posteriori* evaluation of the modularity.

## Types

The object returned by all modularity detection functions has the type
`Partition`.

~~~@docs
Partition
~~~

## Measures of modularity

~~~@docs
Q
~~~

In addition, there is a measure of *realized* modularity:

~~~@docs
Qr
~~~

## Functions for modularity detection

The first function included is `label_propagation`, which is working well for
large graphs. It can also be useful to generate an initial modular partition.

~~~@docs
label_propagation
~~~

For larger graphs (as long as they are not probabilistic), there is the
`louvain` function. It is *not* the most aggressively optimized implementation.

~~~@docs
louvain
~~~

Finally, there is a `brim` function for bipartite networks.

~~~@docs
brim
~~~

## Analyze modularity

~~~@docs
modularity
~~~

## Select the best partition

~~~@docs
best_partition
~~~
