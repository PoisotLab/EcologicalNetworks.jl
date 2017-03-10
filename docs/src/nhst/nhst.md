# Null Hypothesis Significance Testing

NHST is used to determine whether the observed value of a network measure is
larger, or smaller, or similar to, what is expected by chance. The function to
perform a test is typically applied after you have generated randomized networks
using either null models or network permutations.

~~~@docs
test_network_property
~~~

The output is a `NetworkTestOutput` object, with a number of fields.

~~~@docs
EcologicalNetwork.NetworkTestOutput
~~~
