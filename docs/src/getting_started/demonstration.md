# Building a network

Before getting started with the package itself, we will see how we can build a
network, access its content, and iterate over the interactions. This page is
intended to give you some intuitions about how the type system works, before
reading more of the manual.

```@example 1
using SpeciesInteractionNetworks
```

## List of species

We will create a very small network, made of four species and their
interactions. The first step is to define a list of species:

```@example 1
species = [:fox, :vole, :hawk, :turnip]
```

In order to make sure that we are explicit about the type of network we are working with, we will create a representation of this list of species that is unipartite:

```@example 1
nodes = Unipartite(species)
```

## List of interactions

As with species, we want to represent interactions in a way that captures ecological information. In this case, we will use binary interactions (true/0), and work from a matrix, where the rows are the source of the interaction, and the column is its destination. It means that interactions go *from* predator *to* preys.

```@example 1
int_matrix = Bool[
    0 1 0 0;
    0 0 0 1;
    0 1 0 0;
    0 0 0 0
]
```

As this network is binary, we will wrap this matrix into a `Binary` collection of interactions:

```@example 1
edges = Binary(int_matrix)
```

## Assembling the network

The network itself is a collection of nodes and edges. There are a number of
specific checks performed when creating the network, to ensure that we cannot
create an object that makes no sense.

```@example 1
network = SpeciesInteractionNetwork(nodes, edges)
```

The networks are iterable, *i.e.* we can walk through them, specifically one
interaction at a time:

```@example 1
for interaction in network
    println(interaction)
end
```

Internally, this is done by only returning the pairs of species that do not have
a value of zero.

## Basics of network exploration

We can also get a list of the species that establish an interaction with a given
species (in this case, predators):

```@example 1
predecessors(network, :vole)
```

Or the species witch which a given species establishes interactions (in this
case, preys):

```@example 1
successors(network, :fox)
```

Further

```@example 1
subgraph(network, [:fox, :vole, :turnip]) |> interactions
```
