# Analysis of ecological networks

The `EcologicalNetwork` package offers a convenient interface to analyze several
types of ecological networks. Rather than providing multiple measures of the
same property, we selected measures that have been demonstrated to work and be
robust.

You can read more about the selection of measures in:

> Delmas, E. et al. Analyzing ecological networks of species interactions.
bioRxiv 112540 (2017). doi:10.1101/112540

The structure of this documentation is trying to match (as much as possible) the
structure of Delmas *et al.* ([2017][anei]), where most of the measures
presented here are reviewed.

[anei]: http://biorxiv.org/content/early/2017/02/28/112540

<<<<<<< HEAD
## Overview of methods

This table gives an overview of the currently available methods, as a function
of the network type. In the *Quantitative* column, a `D` means that the method
exists *but* works on the *Deterministic* part of the network (*i.e.* the
information about interaction weight is removed). `B`: bipartite; `U`:
unipartite.

| Measure type   | Measure            | Deterministic | Quantitative | Probabilistic |
|:---------------|:-------------------|:-------------:|:------------:|:-------------:|
| degree         |                    |      yes      |     yes      |      yes      |
|                |                    |               |              |               |
| specificity    | PDI                |               |     yes      |               |
|                | RR                 |      yes      |              |               |
|                |                    |               |              |               |
| connectance    |                    |      yes      |      D       |      yes      |
|                |                    |               |              |               |
| link density   |                    |      yes      |              |               |
|                |                    |               |              |               |
| nestedness     | $\eta$             |       B       |              |       B       |
|                | NODF               |       B       |              |               |
|                | WNODF              |               |      B       |               |
|                |                    |               |              |               |
| modularity     | $Q$                |      yes      |     yes      |      yes      |
|                | $Q'_R$             |      yes      |     yes      |      yes      |
|                | label propagation  |      yes      |     yes      |      yes      |
|                |                    |               |              |               |
| motif counting |                    |      yes      |      D       |      yes      |
|                |                    |               |              |               |
| null models    | 1 (connectance)    |      yes      |              |               |
|                | 2 (degree)         |      yes      |              |               |
|                | 3in (columns)      |      yes      |              |               |
|                | 3out (rows)        |      yes      |              |               |
|                |                    |               |              |               |
| swap           | fill               |      yes      |              |               |
|                | generality         |      yes      |              |               |
|                | vulnerability      |      yes      |              |               |
|                | degre distribution |      yes      |              |               |
|                |                    |               |              |               |
| centrality     | Katz               |      yes      |              |      yes      |
|                | Closeness          |      yes      |              |               |
|                |                    |               |              |               |
| paths          | number             |      yes      |              |      yes      |
|                | shortest           |      yes      |     yes      |               |
|                |                    |               |              |               |
| trophic level  | fractional         |       U       |      D       |               |
|                | weighted           |       U       |      D       |               |
|                | position           |       U       |      D       |               |
=======
This package also offers an interface for probabilistic network, about which you
can read more in:

> Poisot, T. et al. The structure of probabilistic networks. Methods in Ecology
and Evolution 7, 303–312 (2016). doi: 10.1111/2041-210X.12468
>>>>>>> 7eeb2e530b56bb0bf5f01b67412911f3e312c4f2
