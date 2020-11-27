import Base.iterate

function iterate(N::T) where {T <: AbstractEcologicalNetwork}
    iterate(interactions(N))
end

function iterate(N::T, state::Int64) where {T <: AbstractEcologicalNetwork}
    iterate(interactions(N), state)
end

function iterate(N::T, state::Nothing) where {T <: AbstractEcologicalNetwork}
    return nothing
end
