"""
    ρ(N::T; range::Bool=true) where {T <: AbstractUnipartiteNetwork}

Returns the spectral radius (the absolute value of the largest real part of the
eigenvalues of the adjacency matrix) of any unipartite network whose
interactions are positive or null. The keyword argument `range` will divide the
spectral radius by the 2-norm of the adjacency matrix, as this represents an
upper bound for the value of the spectral radius.  This is prinmarily useful
whenever networks of different sizes are involved, as the spectral radius scales
with the size of the network.
"""
function ρ(N::T; range::Bool=true) where {T <: AbstractUnipartiteNetwork}
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
