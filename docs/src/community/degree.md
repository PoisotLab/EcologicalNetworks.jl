# Degree distribution and specificity


```@meta
DocTestSetup = quote
  using EcologicalNetwork
end
```

~~~@index
Pages = ["degree.md"]
~~~

## Species richness

~~~@docs
richness
~~~

## Counting degrees

~~~@docs
degree
degree_out
degree_in
~~~

For probabilistic networks only, there are measures of degree variance:

~~~@docs
degree_var
degree_out_var
degree_in_var
~~~

## Meaasures of specificity

All measures of specificity are setup so that maximal specificity is 1, and
maximal generality is 0. By default, specificity of quantitative networks is
measured using the *PDI* index, and the specificity of deterministic networks is
measured using the *RR* index. These two are mathematically equivalent when
applied to a deterministic network.

~~~@docs
specificity
~~~

```@meta
DocTestSetup = nothing
```
