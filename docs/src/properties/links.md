# Links, degree, connectance

## Connectance and number of links

```@docs
sum(N::AbstractEcologicalNetwork)
L(N::AbstractEcologicalNetwork)
links_var(N::ProbabilisticNetwork)
connectance(N::AbstractEcologicalNetwork)
connectance(N::QuantitativeNetwork)
connectance_var(N::ProbabilisticNetwork)
linkage_density(N::DeterministicNetwork)
```

## Degree

```@docs
degree(N::AbstractUnipartiteNetwork)
degree(N::AbstractBipartiteNetwork)
degree(N::QuantitativeNetwork)
degree(N::AbstractEcologicalNetwork, i::Integer)
degree(N::QuantitativeNetwork, i::Integer)
degree_var(N::UnipartiteProbabilisticNetwork)
degree_var(N::BipartiteProbabilisticNetwork)
degree_var(N::ProbabilisticNetwork, i::Integer)
degree_out(N::AbstractEcologicalNetwork)
degree_in(N::AbstractEcologicalNetwork)
degree_out_var(N::ProbabilisticNetwork)
degree_in_var(N::ProbabilisticNetwork)
```

## Species without interactions

```@docs
isdegenerate(N::AbstractEcologicalNetwork)
simplify{T<:AbstractBipartiteNetwork}(N::T)
simplify{T<:AbstractUnipartiteNetwork}(N::T)
```

## Species-level specificity

```@docs
specificity(N::BinaryNetwork)
specificity(N::QuantitativeNetwork)
```
