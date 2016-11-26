# Analysis of ecological networks

The `EcologicalNetwork` package offers a convenient interface to analyse
several types of ecological networks. Rather than providing multiple measures
of the same property, we selected measures that have been demonstrated to
work and be robust.

## Overview of methods

This table gives an overview of the currently available methods, as a
function of the network type. In the *Quantitative* column, a `D` means that
the method exists *but* works on the *Deterministic* part of the network
(*i.e.* the information about interaction weight is removed).

| Measure         | Deterministic | Quantitative | Probabilistic |
|:----------------|:-------------:|:------------:|:-------------:|
| degree          |      yes      |      yes     |      yes      |
| specificity     |      yes      |      yes     |               |
| connectance     |      yes      |       D      |      yes      |
| link density    |      yes      |              |               |
| nestedness      |      yes      |              |      yes      |
| modularity      |      yes      |      yes     |      yes      |
| motif counting  |      yes      |              |      yes      |
| null models     |      yes      |              |               |
| centrality      |      yes      |              |      yes      |
| number of paths |      yes      |              |      yes      |

