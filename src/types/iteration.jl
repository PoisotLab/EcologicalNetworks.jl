import Base.iterate

function network_state(N::T, s::CartesianIndex) where {T <: BinaryNetwork}
    i = s[1]
    j = s[2]
    if has_interaction(N, i, j)
        return (from=species(N; dims=1)[i], to=species(N; dims=2)[j])
    else
        return nothing
    end
end

function network_state(N::T, s::CartesianIndex) where {T <: ProbabilisticNetwork}
    i = s[1]
    j = s[2]
    if has_interaction(N, i, j)
        return (from=species(N; dims=1)[i], to=species(N; dims=2)[j], probability=N[i,j])
    else
        return nothing
    end
end

function network_state(N::T, s::CartesianIndex) where {T <: QuantitativeNetwork}
    i = s[1]
    j = s[2]
    if has_interaction(N, i, j)
        return (from=species(N; dims=1)[i], to=species(N; dims=2)[j], strength=N[i,j])
    else
        return nothing
    end
end

function iterate(N::T) where {T <: AbstractEcologicalNetwork}
    CIdx = CartesianIndices(N.A)
    global state = nothing
    global next = nothing
    for i in 1:length(CIdx)
        if !isnothing(network_state(N, CIdx[i]))
            state = i
            break
        end
    end
    this_state = network_state(N, CartesianIndices(N.A)[state])
    if state < length(CIdx)
        for i in (state+1):length(CIdx)
            if !isnothing(network_state(N, CIdx[i]))
                next = i
                break
            end
        end
    end
    return (this_state, next)
end

function iterate(N::T, state::Int64) where {T <: AbstractEcologicalNetwork}
    CIdx = CartesianIndices(N.A)
    this_state = network_state(N, CartesianIndices(N.A)[state])
    global next = nothing
    if state < length(CIdx)
        for i in (state+1):length(CIdx)
            if !isnothing(network_state(N, CIdx[i]))
                next = i
                break
            end
        end
    end
    next === nothing ? (return (this_state, nothing)) : (return (this_state, next))
end

function iterate(N::T, state::Nothing) where {T <: AbstractEcologicalNetwork}
    return nothing
end
