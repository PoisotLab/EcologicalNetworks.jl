# Indices based on information theory

Indices based on information theory, such as entropy, mutual information etc, can easily be computed. To this end, the ecological network is transformed in a bivariate distribution. This is done by normalizing the adjacency or incidence matrix to obtain a doubly stochastic matrix. The information theoretic indices are computed either from this matrix or directly from the ecological network. Note that when using an array is input, the functions do not perform any checks whether the matrix is normalized and nonnegative. When the input is an ecological network, the functions automatically convert the network to a normalized probability matrix.

One can compute individual indices or use the function `information_decomposition` which performs the entire decomposition at once.

Indices can be calculated for the joint distribution, as well as for the marginal distributions of the two trophic levels (if applicable), by changing an optional argument `dim=1` of the function.

## Network conversion

```@docs
make_joint_distribution
```

## Indices

```@docs
entropy
conditional_entropy
mutual_information
variation_information
potential_information
diff_entropy_uniform
```

## Decomposition

```@docs
information_decomposition
```

## Effective interactions

```@docs
convert2effective
```
