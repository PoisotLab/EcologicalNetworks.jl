function omnivory(N::T) where {T <: UnipartiteNetwork}
    OI = Dict([s => 0.0 for s in species(N)])

    TL = trophic_level(N)
    k = degree_in(N)

    for sp_i in species(N)

        # Species with no interaction have an omnivory index of 0
        k[sp_i] > 0 || continue

        # For every species, we set its initial omnivory to 0
        oi = 0.0
        for sp_j in species(N)
            # Then for every species it consumes, we ha
            tl_diff = (TL[sp_j] - (TL[sp_i]-1.0)).^2.0
            corr = N[sp_j,sp_i]/k[sp_i]
            oi += tl_diff * corr
        end
        OI[sp_i] = oi
    end

    return OI
end
