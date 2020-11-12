"""
    functional_cartography(N::T, L::Dict{E,Int64}) where {T<:BinaryNetwork, E}

This function will take the output of a modularity analysis (*i.e.* a network
and a partition), and return a dictionary where every species is associated to
its functional role, as defined in Olesen et al (2005). The first element is the
within-module degree z-score, and the second is the participation coefficient.

#### References

Guimerà, R., Amaral, L.A.N., 2005. Cartography of complex networks: modules and
universal roles. Journal of Statistical Mechanics: Theory and Experiment 2005,
P02001. https://doi.org/10.1088/1742-5468/2005/02/P02001

Guimerà, R., Nunes Amaral, L.A., 2005. Functional cartography of complex
metabolic networks. Nature 433, 895–900. https://doi.org/10.1038/nature03288

Olesen, J.M., Bascompte, J., Dupont, Y.L., Jordano, P., 2007. The modularity of
pollination networks. Proceedings of the National Academy of Sciences 104,
19891–19896. https://doi.org/10.1073/pnas.0706375104
"""
function functional_cartography(N::T, L::Dict{E,Int64}) where {T<:BinaryNetwork, E}
    κ = Dict{last(eltype(N)), Integer}()
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
    deg_N = degree(N)
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
        # If the standard deviation is NaN, we return 0 for the z-score
        zsc = isnan(S[L[s]][2]) ? 0.0 : (κ[s] - S[L[s]][1])/S[L[s]][2]
        carto[s] = (zsc, 1-sum((ks./deg_N[s]).^2))
    end

    return carto
end
