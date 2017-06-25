# Plotting

Currently, plotting is only implemented for `Bipartite` networks (and only
partially so). Plotting uses the `Plots.jl` package, so you can simply use:

```julia
plot(N)
```

where `N` is a network object. By default, species are sorted by degree. If you
want species to be sorted by module, you need to pass a `Partition` object too:


~~~julia
plot(N, P)
~~~
