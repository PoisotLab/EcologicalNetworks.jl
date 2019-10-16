function ρ(N::T; range::Bool=true) where {T <: AbstractUnipartiteNetwork}
    @assert minimum(N.A) ≥ zero(eltype(N.A))
    absolute_real_part = abs.(real.(eigvals(N.A)))
    range && return maximum(absolute_real_part)/norm(N.A)
    return maximum(absolute_real_part)
end

function ρ(N::T; varargs...) where {T <: AbstractBipartiteNetwork}
    return ρ(convert(AbstractUnipartiteNetwork, N); varargs...)
end
