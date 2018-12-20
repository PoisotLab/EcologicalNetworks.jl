# Indices based on information theory

The information theoretic analysis of an interaction network can start from a probability
matrix or from a bipartite ecological network. Note that when using a matrix,
the functions do not perform any checks whether the matrix is normalised.
When the input is a bipartite ecological network, the functions automatically convert
the network to a normalised probability matrix.

One can compute individual indices or use the function *information_decomposition*
which performs the entire decomposition at once.

Indices can be calculated for the joint distribution, as well as for the marginal
distributions of the two trophic levels (if applicable), by changing an optional argument of the function.

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
