# Null models

~~~@setup enet
using EcologicalNetwork
~~~

`EcologicalNetwork` offers a number of ways to draw random binary networks
from a template of probabilities. This is useful to generate networks under
a null model, for example. All these functions will respect the fact that
the network in bipartite or unipartite.

## Creating a deterministic network from a probabilistic network

There are a number of ways to generate a deterministic network from a
probabilistic one. All of these functions take a network on a class belonging
to `ProbabilisticNetwork`, and return a network of a class belonging to
`DeterministicNetwork`.

### Convert to deterministic

The first is simply to assing `true` to all interactions
with a non-0 probability, and `false` to the others. This is done with the
`make_binary` function:

~~~@example enet
N = UnipartiteProbaNetwork(eye(3))
B = make_binary(N)
B.A
~~~

~~~@docs
make_binary
~~~

### Using a threshold

The second way is to determine a cutoff for probabilities, below which they
will be assigned `false`. This is done through `make_threshold`:

~~~@example enet
N = UnipartiteProbaNetwork(rand((4, 4)))
B = make_threshold(N, 0.5)
B.A
~~~

~~~@docs
make_threshold
~~~

### Random draws

The last way to convert a probabilistic network to a deterministic one is
to perform one random draw for each interaction. In this scenario, `true` is
assigned with a probability $P_{ij}$. This is done with the `make_bernoulli`
function:

~~~@example enet
N = BipartiteProbaNetwork(rand((4, 4)))
B = make_bernoulli(N)
B.A
~~~

~~~@docs
make_bernoulli
~~~

## Creating a probabilistic network from a deterministic network

The inverse operation can be done using the `nullX` functions. These functions
use informations about the degree distribution to generate probabilistic
networks:

~~~@docs
null1
null2
null3in
null3out
~~~

For an example:

~~~@example enet
N = make_bernoulli(BipartiteProbaNetwork(rand(3, 5)))
null2(N).A
~~~
