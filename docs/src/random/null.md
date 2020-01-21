# Null models

Randomization of networks is mostly used to perform null hypothesis significance
testing, or to draw random realizations of a probabilistic network. There are
two ways to perform networks randomization: either by shuffling interactions
within the networks while enforcing some constraints (`shuffle`) or by drawing
random samples from a probabilistic network (`rand`).

## Draw a network from a probabilistic network

```@docs
rand
```

## Generate probabilistic networks from deterministic networks

These functions generate a probabilistic network from a deterministic network,
where the probability of every interaction is determined by the degree
distribution (or connectance) of the network.

```@docs
null1
null2
null3
```

### Random Dot Product Graph model

The interaction probability in a Random Dot Product Graphs model are given by the dot product of species representations in two metric spaces of a given dimension (one describing species as consumers, one as producers -- or predators and preys).

```@docs
RDPG
```

The Random Dot Product Graph spaces are computed via a truncated Singular Value Decomposition of the food web adjacency matrix.

```@docs
svd_truncated
```

## Shuffle interactions

```@docs
shuffle!
shuffle
```
