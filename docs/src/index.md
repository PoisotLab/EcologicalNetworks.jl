# Analysis of ecological networks

The `EcologicalNetwork` package offers a convenient interface to analyse
several types of ecological networks.

## Overview of methods

This table gives an overview of the currently available methods, as a
function of the network type. In the *Quantitative* column, a `D` means that
the method exists *but* works on the *Deterministic* part of the network
(*i.e.* the information about interaction weight is removed).

| Measure        | Deterministic | Quantitative | Probabilistic |
|:---------------|:-------------:|:------------:|:-------------:|
| degree         |      yes      |      yes     |      yes      |
| specificity    |      yes      |      yes     |               |
| connectance    |      yes      |              |      yes      |
| nestedness     |      yes      |              |      yes      |
| modularity     |      yes      |      yes     |      yes      |
| motif counting |      yes      |              |      yes      |
| null models    |      yes      |              |               |

## Table of contents

~~~@contents
Pages = [
    "man/types.md",
    "man/data.md",
    "man/nullmodels.md"
    "man/modularity.md"
]
Depth = 2
~~~

