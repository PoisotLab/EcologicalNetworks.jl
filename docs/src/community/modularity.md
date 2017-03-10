# Modularity

There are a number of modularity-related functions in `EcologicalNetworks`. The
optimal modularity structure is detected by optimizing $Q$, which returns values
increasingly close to unity when the modular structure is strong. The $Q_R$
measure is also included for *a posteriori* evaluation of the modularity.

## Analyze modularity

~~~@docs
modularity
~~~

## Initial assignment

~~~@docs
label_propagation
~~~

## Select the best partition

~~~@docs
best_partition
~~~

## Measures of modularity

~~~@docs
Q
~~~

In addition, there is a measure of *realized* modularity:

~~~@docs
Qr
~~~

## Types

~~~@docs
Partition
~~~
