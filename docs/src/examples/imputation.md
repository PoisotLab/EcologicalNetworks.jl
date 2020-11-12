## Interaction imputation

In the final example, we will apply the linear filtering method of @StocPois17
to suggest which negative interactions may have been missed in a network.
Starting from a binary network, this approach generates a quantitative network,
in which the weight of each interaction is the likelihood that it exists -- for
interactions absent from the original network, this suggests that they may have
been missed during sampling. This makes this approach interesting to guide
empirical efforts during the notoriously difficult task of sampling ecological
networks [@Jord16; @Jord16a].

In the approach of @StocPois17, the filtered interaction matrix (*i.e.* the
network of weights) is given by

\begin{equation}
F_{ij} = \alpha_1Y_{ij} + \alpha_2\sum_k\frac{Y_{kj}}{n} + \alpha_3\sum_l\frac{Y_{il}}{m} + \alpha_4\frac{\sum Y}{n\times m} \,,
\end{equation}

where $\alpha$ is a vector of weights summing to 1, and $(n,m)$ is the size of
the network. Note that the sums along rows and columns are actually the in and
out degree of species.  This is implemented in `EcologicalNetworks` as the
`linearfilter` function. As in @StocPois17, we set all values in $\alpha$ to
$1/4$. We can now use this function to get the top interaction that, although
absent from the sampled network, is a strong candidate to exist based on the
linear filtering output:

```julia
N = networks[50]
F = linearfilter(N)
```

We would like to separate the weights in 3: observed interactions, interactions
that are not observed in this network but are observed in the metaweb, and
interactions that are never observed. `EcologicalNetworks` has the
`has_interaction` function to test this, but because `BinaryNetwork` are using
Boolean values, we can look at the network directly:

```julia
scores_present = sort(
  filter(int -> N[int.from, int.to], interactions(F)),
  by = int -> int.probability,
  rev = true);

scores_metaweb = sort(
  filter(int -> (!N[int.from,int.to])&(metaweb[int.from, int.to]), interactions(F)),
  by = int -> int.probability,
  rev = true);

scores_absent = sort(
  filter(int -> !metaweb[int.from,int.to], interactions(F)),
  by = int -> int.probability,
  rev = true);
```

The results of this analysis are presented in @fig:imputation: the weights
$F_{ij}$ of interactions that are present locally ($Y_{ij}=\text{true}$) are
*always* larger that the weight of interactions that are absent; furthermore,
the weight of interactions that are absent locally are equal to the weight of
interactions that are also absent globally, strongly suggesting that this
network has been correctly sampled.

```julia; echo=false
nx, ny = range(0.0, stop=1.0, length=length(scores_present)), [x.probability for x in scores_present]
pl = plot(nx, ny, grid=false, frame=:origin, lw=2, lab="Present locally", c=:black)
nx, ny = range(0.0, stop=1.0, length=length(scores_metaweb)), [x.probability for x in scores_metaweb]
plot!(pl, nx, ny, c=:black, lab="Present globally")
nx, ny = range(0.0, stop=1.0, length=length(scores_absent)), [x.probability for x in scores_absent]
plot!(pl, nx, ny, c=:darkgrey, ls=:dash, lab="Absent")
xaxis!(pl, "Relative rank", (0,1))
yaxis!(pl, "Interaction weight", (0,1))
savefig("figures/imputation.pdf")
```

![Relative weights (higher weights indicates a larger chance that the interaction has been missed when sampling) in one of the host-parasite networks according to the linear filter model of @StocPois17.](figures/imputation.pdf){#fig:imputation}
