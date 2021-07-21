# Optimal transportation for species interaction networks

By solving an *optimal transportation* problem, one can estimate the interaction intensities given (1) a matrix of interaction utility values (i.e., the preferences for certain interactions between the species) and (2) the abundances of the top and bottom species. It hence allows predicting *how* species will interact. The interactions estimated intensities are given by the ecological coupling matrix $Q$, which has the optimal trade-off between utility (enriching for prefered interactions) and entropy (interactions are distributed as randomly as possible). The function `optimaltransportation` has the following inputs:
- a utility matrix `M`;
- the (relative) abundances of the top and bottom species `a` and `b`;
- the entropic regularization parameter `λ` (set default to 1).
For details, we refer to the paper presenting this framework.

```@docs
optimaltransportation
```

## References

Stock, M., Poisot, T., & De Baets, B. (2021). « Optimal transportation theory for
species interaction networks. » Ecology and Evolution, 00(1), ece3.7254.
https://doi.org/10.1002/ece3.7254