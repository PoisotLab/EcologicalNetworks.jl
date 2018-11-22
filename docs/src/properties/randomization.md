# Randomization of networks

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
null3in
null3out
```

## Shuffle interactions

```@docs
shuffle!
shuffle
```

## Generate structural network models

Structure of ecological networks is non-random. Network architecture can have a strong effect on important ecosystem properties (Mougi and Kondoh 2012, Thebault and Fontaine 2010). Structural network models (phenomenological stochastic models) able to reproduce realistic structures of empirical networks are a useful tool. Many of the structural features of food-webs can be modelled with small number of simple rules. Despite that these models can reproduce well some of the second order characteristics of empirical food-webs (Stouffer et al. 2005). There are many applications for realistic network structures e.g. to simulate biomass dynamics using dynamical models or study extinction cascades.

Many models able to simulate network structure have been proposed. `EcologicalNetworks` provides functions to generate random ecological networks of the `UnipartiteNetwork` type. Listed below are algorithms most often used in ecological studies.

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

In order to reproduce more faithfully properties of complex and multidimensional natural nested hierarchy model tries to use simple rules to incorporate also the phylogenetical similarity in resource composition of predators.

```@docs
nestedhierarchymodel
```

### Minimum potential niche model

This model attempts to explicitly simulate forbidden links in empirical food webs.

```@docs
mpnmodel
```
