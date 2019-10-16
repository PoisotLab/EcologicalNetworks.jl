function ρ(N::T; range::Bool=true) where {T <: AbstractUnipartiteNetwork}
    @assert minimum(N.A) ≥ zero(eltype(N.A))

end

function ρ(N::T; varargs...) where {T <: AbstractBipartiteNetwork}
    return ρ(convert(AbstractUnipartiteNetwork, N); varargs...)
end
