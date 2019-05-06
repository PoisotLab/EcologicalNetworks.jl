# Resilience

Species interaction networks provide the interactions of the individual species.
We provide the metrics proposed by Gao et al (2016) that summarize the global
behaviour of complex unipartite networks. The dynamics of a system of N components
(nodes/species) can follow the coupled nonlinear differential equation

$$
\frac{\text{d}x_i}{\text{d}t} = F(x_i) + \sum_{j=1}^N A_{ij}G(x_i, x_j)
$$

where the adjacency matrix $$A$$ captures the interaction between the components.

This system can be descibed in 1-D using an effective term

$$
\frac{\text{d}x_\text{eff}}{\text{d}t} = F(x_\text{eff}) + \beta_\text{eff}G(x_\text{eff}, x_\text{eff})
$$

with $$\beta_\text{eff}$$ a single resilience parameter which can capture
the effect of perturbating the system (node/link removal, weight change...).
This resience parameter can be computed from an `AbstractUnipartiteNetwork`
using the functions `βeff` or `resilience`.

It can be shown that

$$
\beta_\text{eff} = \langle s \rangle + \mathcal{S}  \mathcal{H}\,,
$$

with

- $$\langle s \rangle$$ the average weighted degree (computed using `s_mean`),
- $$\mathcal{S}$$ the symmetry(computed using `symmetry`),
- $$\mathcal{H}$$ the heterogenity (computed using `heterogenity`).


> Goa, J., Barzael, B. and Barabási 2016. Universal resilience patterns in complex networks.
> Nature 530(7590), 307-312. doi:10.1038/nature16948

## Available functions

```@docs
s_in
s_out
s_mean
σ_in
σ_out
symmetry
heterogenity
βeff
resilience
```
