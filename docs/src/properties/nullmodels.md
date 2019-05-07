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

## Shuffle interactions

```@docs
shuffle!
shuffle
```

## Generate structural network models

Structure of ecological networks is non-random. Network architecture can have a strong effect on important ecosystem properties (Mougi and Kondoh 2012, Thébault and Fontaine 2010). Many of the structural features of food-webs can be simulated using small number of simple rules. Despite this simplicity these models can often accurately reproduce some of the second order characteristics of empirical food-webs (Stouffer et al. 2005). These characteristics of phenomenological stochastic models allow for their wide applications e.g. to simulate biomass dynamics using dynamical models or study extinction cascades.

> Mougi, A. and Kondoh, M. (2012) ‘Diversity of Interaction Types and Ecological Community Stability’, Science, 337(6092), pp. 349–351. doi: 10.1126/science.1220529.
> Thébault, E. and Fontaine, C. (2010) ‘Stability of Ecological Communities and the Architecture of Mutualistic and Trophic Networks’, Science, 329(5993), pp. 853–856. doi: 10.1126/science.1188321.
> Stouffer, D. B. et al. (2005) ‘Quantitative Patterns in the Structure of Model and Empirical Food Webs’, Ecology, 86(5), pp. 1301–1311. doi: 10.1890/04-0957.

Many models with various interactions assignment algorithms have been proposed. `EcologicalNetworks` provides functions to generate random ecological networks of the `UnipartiteNetwork` type. Listed below are those most often used in ecological studies.

### Cascade model

This model uses one abstract trophic trait. For any given consumer links can be randomly assigned to a resource species with the trait value smaller than that of a consumer.

```@docs
cascademodel
```

### Niche model

Niche model extended cascade model by introducing ranges for each consumer. In this model consumers can predate on resources which trait values are within the predators' 'niche' range.

```@docs
nichemodel
```

### Nested hierarchy model

In order to reproduce more faithfully properties of complex and multidimensional natural nested hierarchy model tries to use simple rules to incorporate also the phylogenetic similarity in resource composition of predators.

```@docs
nestedhierarchymodel
```

### Minimum potential niche model

This model attempts to explicitly simulate forbidden links in empirical food webs.

```@docs
mpnmodel
```
