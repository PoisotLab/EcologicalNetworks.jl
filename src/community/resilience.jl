#=
Some functions from *Universal resilience patterns in complex networks*
by Gao et al. (2016)
=#

using StatsBase: mean, std

"""
    s_in(N::AbstractUnipartiteNetwork)

Computes the vector of incoming weighted degrees of an unipartite network.
"""
s_in(N::AbstractUnipartiteNetwork) = sum(N.A, dims=2)

"""
    s_out(N::AbstractUnipartiteNetwork)

Computes the vector of outgoing weighted degrees of an unipartite network.
"""
s_out(N::AbstractUnipartiteNetwork) = sum(N.A, dims=1)'

"""
    s_mean(N::AbstractUnipartiteNetwork)

Computes the average weighted degree. This is proportional to the (weighted)
density of interactions.
"""
s_mean(N::AbstractUnipartiteNetwork) = sum(N.A) / size(N.A, 1)

"""
    σ_in(N::AbstractUnipartiteNetwork)

Computes the standard deviation of the ingoing weighted degree of an unipartite
network.
"""
σ_in(N::AbstractUnipartiteNetwork) = std(s_in(N), corrected=false)

"""
    σ_out(N::AbstractUnipartiteNetwork)

Computes the standard deviation of the outgoing weighted degree of an unipartite
network.
"""
σ_out(N::AbstractUnipartiteNetwork) = std(s_out(N), corrected=false)

"""
    symmetry(N::AbstractUnipartiteNetwork)

Computes the symmetry between s^in and s^out (the in- and outgoing weighted
degree of an unipartite network). This is computed as the Pearson correlation
between the s^in and s^out. It is hence a value between -1 and 1, where high
positive values indicate that species with many outgoing degrees tend to have
many ingoing degrees and negative values mean the opposite. An undirected network
is perfectly symmetric but, for example, a food web where predators are less likely
to be prey would have a negative symmetry.

> Goa, J., Barzael, B. and Barabási 2016. Universal resilience patterns in complex networks.
> Nature 530(7590), 307-312. doi:10.1038/nature16948

"""
symmetry(N::AbstractUnipartiteNetwork) = (mean(s_in(N) .* s_out(N)) - mean(s_in(N)) * mean(s_out(N))) / (σ_in(N) * σ_out(N))

"""
    heterogenity(N::AbstractUnipartiteNetwork)

Computes the heterogenity for an unipartite network, a topological characteristic
which quantifies the difference in in- and outgoing degrees between species. It
is computed as σ_in * σ_out / s_mean. A value of 0 indicates that all species
have the same (weighted) in- and outdegrees.

> Goa, J., Barzael, B. and Barabási 2016. Universal resilience patterns in complex networks.
> Nature 530(7590), 307-312. doi:10.1038/nature16948

"""
heterogenity(N::AbstractUnipartiteNetwork) = (σ_in(N) * σ_out(N)) / s_mean(N)

"""
    βeff(N::AbstractUnipartiteNetwork)

A resilience parameters described by Gao et al. (2016). It is a global parameters
describing the dynamics of an unipartite network as an effective 1D equation of
the form

f(xeff) = F(xeff) + βeff G(xeff, xeff)

i.e. describing a second-order term representing the effect of the network on the
dynamics of the 'effective state' xeff of the system.

> Goa, J., Barzael, B. and Barabási 2016. Universal resilience patterns in complex networks.
> Nature 530(7590), 307-312. doi:10.1038/nature16948

"""
βeff(N::AbstractUnipartiteNetwork) = dot(s_in(N), s_out(N)) / sum(N.A)

"""
    resilience(N::AbstractUnipartiteNetwork)

A resilience parameters described by Gao et al. (2016). It is a global parameters
describing the dynamics of an unipartite network as an effective 1D equation of
the form

f(xeff) = F(xeff) + βeff G(xeff, xeff)

i.e. describing a second-order term representing the effect of the network on the
dynamics of the 'effective state' xeff of the system.

> Goa, J., Barzael, B. and Barabási 2016. Universal resilience patterns in complex networks.
> Nature 530(7590), 307-312. doi:10.1038/nature16948

"""
resilience(N::AbstractUnipartiteNetwork) = βeff(N)
