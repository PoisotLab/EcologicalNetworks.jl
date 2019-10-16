ρ_phillips(N::T, v::Float64) where {T <: AbstractUnipartiteNetwork}  = v/((2*links(N)*(richness(N)-1))/richness(N))^0.5
ρ_ska(N::T, v::Float64) where {T <: AbstractUnipartiteNetwork} = v/sqrt(links(N))
ρ_raw(N::T, v::Float64) where {T <: AbstractUnipartiteNetwork} = v

"""
    ρ(N::T; range::Bool=true) where {T <: AbstractUnipartiteNetwork}

Returns the spectral radius (the absolute value of the largest real part of the
eigenvalues of the adjacency matrix) of any unipartite network whose
interactions are positive or null.

Note that the spectral radius has been suggested as a measure of nestedness by
Staniczenko *et al.* (2013). Phillips (2011) uses it as a measure of the ability
of a system to dampen or absorb perturbations.

#### Maximal values

The spectral radius is sensitive to network size, and to a certain extent to the
number of links. The keyword argument `range` will divide return a ranged
version of the spectral radius, so that it is expressed relatively to its
maximal value. The `range` argument takes a *function*, which requires two
arguments: the network (which must be unipartite), and the value of the spectral
radius.

Options that come with `EcologicalNetworks.jl` (where L is the number of links
and S the number of nodes) are:

1. `EcologicalNetworks.ρ_phillips`: divides by the square root of (2L(S-1))/S, as in Phillips (20110)
1. `EcologicalNetworks.ρ_ska`: divides by the square root of L, as in Staniczenko *et al.* (2013) - this is the **default**
1. `EcologicalNetworks.ρ_raw`: returns the raw value

#### References

Phillips, J.D., 2011. The structure of ecological state transitions:
Amplification, synchronization, and constraints in responses to environmental
change. Ecological Complexity, 8, 336–346.
https://doi.org/10.1016/j.ecocom.2011.07.004

Staniczenko, P.P.A., Kopp, J.C., Allesina, S., 2013. The ghost of nestedness in
ecological networks. Nat Commun 4, 1391. https://doi.org/10.1038/ncomms2422
"""
function ρ(N::T; range=EcologicalNetworks.ρ_ska) where {T <: AbstractUnipartiteNetwork}
    @assert minimum(N.A) ≥ zero(eltype(N.A))
    absolute_real_part = abs.(real.(eigvals(N.A)))
    range && return maximum(absolute_real_part)/norm(N.A)
    return maximum(absolute_real_part)
end

"""
    ρ(N::T; varargs...) where {T <: AbstractBipartiteNetwork}

Bipartite version of the spectral radius. In practice, this casts the network
into its unipartite representation, since the spectral radius only makes sense
for square matrices.
"""
function ρ(N::T; varargs...) where {T <: AbstractBipartiteNetwork}
    return ρ(convert(AbstractUnipartiteNetwork, N); varargs...)
end
