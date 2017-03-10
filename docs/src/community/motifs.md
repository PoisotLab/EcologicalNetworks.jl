# Counting motifs

There are a number of ways to...

!!! note
    The enumeration of motifs can take a little while. It depends on the number
    of nodes in the networks, and in the number of nodes in the motif. It may be
    wise, in case you want to count several motifs on a single network, to use
    Julia's parallel computing abilities to speed things up.

## How it works

Internally, the code to count motifs is *Not Elegant*™. Every motif is
represented by its adjacency matrix, as a `DeterministicNetwork` object. Then
*all* possible induced sub-graphs with the same number of nodes (at either level
if this is a `Bipartite`) are extracted, and matched against all *unique*
possible permutations of the motif. If there is a match, then this induced
subgraph is an instance of this motif.

~~~@docs
motif
~~~

## Caveats

The motifs are counted in a way that ignore self-links. This should not be an
issue most of the time, and was also the ways this was done in most publications
counting motifs in ecological networks.

## Usual motifs

~~~@docs
unipartitemotifs
~~~
