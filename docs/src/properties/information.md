# Indices based on information theory

Indices based on information theory, such as entropy, mutual information etc, can easily be computed. To this end, the ecological network is transformed in a bivariate distribution. This is done by normalizing the adjacency or incidence matrix to obtain a doubly stochastic matrix. The information theoretic indices are computed either from this matrix or directly from the ecological network. Note that when using an array is input, the functions do not perform any checks whether the matrix is normalized and nonnegative. When the input is an ecological network, the functions automatically convert the network to a normalized probability matrix.

One can compute individual indices or use the function `information_decomposition` which performs the entire decomposition at once. This decomposition yields for a given network the deviation of the marginal distributions of the species with the uniform distribution (quantifying the evenness), the mutual information (quantifying the specialisation) and the variance of information (quantifying the freedom and stability of the interactions). These indices satisfy the following balance equation for the top ($T$) and bottom ($B$) throphic level:

$$
\log(nm) = D(B,T) + 2 I(B;T) + V(B;T)
$$

$$
\log(n) = D(B) + I(B;T) + H(B|T)
$$

$$
\log(m) = D(T) + I(B;T) + H(T|B)
$$

Here, $n$ and $m$ are number of bottom and top species, respectively.

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

## References

Stock, M.; Hoebeke, L.; De Baets, B. « Disentangling the Information in Species Interaction Networks ».
Entropy 2021, 23, 703. https://doi.org/10.3390/e23060703