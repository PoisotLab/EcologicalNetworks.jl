"""
    s(N::AbstractUnipartiteNetwork; dims::Union{Nothing,Integer}=nothing)

Computes the average weighted degree. This is proportional to the (weighted)
density of interactions.

If dims is provided, the incoming (`dims=1`) or outgoing (`dims=2`) is computed.
"""
function s(N::AbstractUnipartiteNetwork; dims::Union{Nothing,Integer}=nothing)
    dims == 1 && return vec(sum(N, dims=2))
    dims == 2 && return vec(sum(N, dims=1))
    if isnothing(dims)
        return sum(N) / size(N)[1]
    end
end

"""
    σ_in(N::AbstractUnipartiteNetwork)

Computes the standard deviation of the ingoing weighted degree of an unipartite
network.
"""
σ_in(N::AbstractUnipartiteNetwork) = Statistics.std(s(N, dims=1), corrected=false)

"""
    σ_out(N::AbstractUnipartiteNetwork)

Computes the standard deviation of the outgoing weighted degree of an unipartite
network.
"""
σ_out(N::AbstractUnipartiteNetwork) = Statistics.std(s(N, dims=2), corrected=false)

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
symmetry(N::AbstractUnipartiteNetwork) = (Statistics.mean(s(N, dims=1) .* s(N, dims=2)) - Statistics.mean(s(N, dims=1)) * Statistics.mean(s(N, dims=2))) / (σ_in(N) * σ_out(N))

"""
    heterogeneity(N::AbstractUnipartiteNetwork)

Computes the heterogeneity for an unipartite network, a topological characteristic
which quantifies the difference in in- and outgoing degrees between species. It
is computed as σ_in * σ_out / s_mean. A value of 0 indicates that all species
have the same (weighted) in- and outdegrees.

> Goa, J., Barzael, B. and Barabási 2016. Universal resilience patterns in complex networks.
> Nature 530(7590), 307-312. doi:10.1038/nature16948

"""
heterogeneity(N::AbstractUnipartiteNetwork) = (σ_in(N) * σ_out(N)) / s(N)

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
resilience(N::AbstractUnipartiteNetwork) = dot(s(N, dims=1), s(N, dims=2)) / sum(N)
