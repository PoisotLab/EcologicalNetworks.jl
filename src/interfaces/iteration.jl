function Base.IteratorSize(::Type{T}) where {T <: AbstractEcologicalNetwork}
    return Base.HasLength()
end

function Base.IteratorEltype(::Type{T}) where {T <: AbstractEcologicalNetwork}
    return Base.EltypeUnknown()
end

function Base.isempty(N::T) where {T <: AbstractEcologicalNetwork}
    return iszero(length(N))
end

function _network_state(N::T, i::Int64) where {T <: BinaryNetwork}
    f,t = findall(!iszero, N.edges)[i].I
    return (from=species(N;dims=1)[f],to=species(N;dims=2)[t])
end

function _network_state(N::T, i::Int64) where {T <: QuantitativeNetwork}
    f,t = findall(!iszero, N.edges)[i].I
    return (from=species(N;dims=1)[f],to=species(N;dims=2)[t],strength=N[f,t])
end

function _network_state(N::T, i::Int64) where {T <: ProbabilisticNetwork}
    f,t = findall(!iszero, N.edges)[i].I
    return (from=species(N;dims=1)[f],to=species(N;dims=2)[t],probability=N[f,t])
end

function Base.iterate(N::T) where {T <: AbstractEcologicalNetwork}
    isempty(N) && return nothing
    return (_network_state(N, 1), 1)
end

function Base.iterate(N::T, state::Int64) where {T <: AbstractEcologicalNetwork}
    next = state == length(N) ? nothing : state+1
    isnothing(next) && return nothing
    return (_network_state(N, state), next)
end