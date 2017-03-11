# Analysis of ecological networks

The `EcologicalNetwork` package offers a convenient interface to analyse
several types of ecological networks. Rather than providing multiple measures
of the same property, we selected measures that have been demonstrated to
work and be robust.

The structure of this documentation is trying to match (as much as possible) the
structure of Delmas *et al.* ([2017][anei]), where most of the measures
presented here are reviewed.

[anei]: http://biorxiv.org/content/early/2017/02/28/112540

## Overview of methods

This table gives an overview of the currently available methods, as a
function of the network type. In the *Quantitative* column, a `D` means that
the method exists *but* works on the *Deterministic* part of the network
(*i.e.* the information about interaction weight is removed).

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
| nestedness     | $\eta$             |   bipartite   |              |   bipartite   |
|                | NODF               |   bipartite   |              |               |
|                | WNODF              |               |  bipartite   |               |
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
| trophic level  | fractional         |  unipartite   |              |               |
|                | weighted           |  unipartite   |              |               |
