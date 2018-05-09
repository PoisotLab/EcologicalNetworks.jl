# Conversions

Conversions between types are used to perform two usual operations: make a
bipartite network unipartite, and remove quantitative information. There are two
high-level functions which work by using the union types, and a series of
type-to-type functions (the later should be avoided, and exists only to make the
high-level functions work).

## High-level interface

```@docs
convert(::Type{AbstractUnipartiteNetwork}, N::AbstractBipartiteNetwork)
convert(::Type{BinaryNetwork}, N::QuantitativeNetwork)
```

## Type-to-type conversions

```@docs
convert{IT}(::Type{UnipartiteNetwork}, N::BipartiteNetwork{IT})
convert{NT,IT}(::Type{BipartiteNetwork}, N::BipartiteQuantitativeNetwork{NT,IT})
convert{NT,IT}(::Type{UnipartiteNetwork}, N::UnipartiteQuantitativeNetwork{NT,IT})
convert{NT,IT}(::Type{UnipartiteProbabilisticNetwork}, N::BipartiteProbabilisticNetwork{NT,IT})
convert{NT,IT}(::Type{UnipartiteQuantitativeNetwork}, N::BipartiteQuantitativeNetwork{NT,IT})
```
