"""
    functional_cartography(N::T, L::Dict{E,Int64}) where {T<:BinaryNetwork, E<:AllowedSpeciesTypes}


"""
function functional_cartography(N::T, L::Dict{E,Int64}) where {T<:BinaryNetwork, E<:AllowedSpeciesTypes}
    κ = Dict{last(eltype(N)), Int64}()
    S = Dict{Int64,Tuple{Float64, Float64}}()
    carto = Dict{last(eltype(N)),Tuple{Float64, Float64}}()

    for s in species(N)
        sp_module = L[s]
        k_i = 0
        if s ∈ species(N; dims=2)
            for s2 in N[:,s]
                L[s2] == sp_module && (k_i += 1)
            end
        end
        if s ∈ species(N; dims=1)
            for s2 in N[s,:]
                L[s2] == sp_module && (k_i += 1)
            end
        end
        κ[s] = k_i
    end

    for s in values(L)
        sp = filter(k -> k.second == s, L)
        k_i = [get(κ, x, 0) for x in keys(sp)]
        S[s] = (mean(k_i), std(k_i))
    end

    # Participation coefficient
    for s in species(N)
        ks = zeros(Int64, length(unique(values(L))))
        if s ∈ species(N; dims=2)
            for s2 in N[:,s]
                ks[L[s2]] += 1
            end
        end
        if s ∈ species(N; dims=1)
            for s2 in N[s,:]
                ks[L[s2]] += 1
            end
        end
        carto[s] = ((κ[s] - S[L[s]][1])/S[L[s]][2], 1-sum((ks./degree(N)[s]).^2))
    end

    return carto
end
