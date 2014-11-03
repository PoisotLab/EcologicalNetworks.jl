---
author: Timothée Poisot
---

# Probabilistic network measures

## Data format

All functions assume that the networks will be given as matrices of
`Float64`. All values should be between `0.0` and `1.0` (included), since
these are probabilities. There are  two sorts of matrices: adjacency,
and incidence. *Most* function assume incidence matrices, but should work
equally well with any type (only `degree` will create trouble).

## Overview
