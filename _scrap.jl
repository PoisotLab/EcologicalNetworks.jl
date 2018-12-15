using Pkg
Pkg.activate(".")
using EcologicalNetworks
using Random
import Random.shuffle!

N = web_of_life("A_HP_002")
Y = copy(N)

function quanti_shuffle_valid(a, i1, i2)
    u1 = length(unique(i1)) == 2
    u2 = length(unique(i2)) == 2
    mi = minimum(a[i1,i2]) != zero(eltype(a))
    return u1 & u2 & mi
end

function shuffle!(N::BipartiteQuantitativeNetwork{Int64,K}; constraint::Symbol=:degree, lims=(0, Inf)) where {K <: AllowedSpeciesTypes}
    constraint ∈ [:degree, :generality, :vulnerability, :fill] || throw(ArgumentError("The constraint argument you specificied ($(constraint)) is invalid -- see ?shuffle! for a list."))
    first(lims) < last(lims) || throw(ArgumentError("The interval you used for limits, $(lims), is invalid"))
    all(first(lims) .<= N.A .<= last(lims)) || throw(ArgumentError("The interval you used for limits, $(lims), is smaller than the range of network values"))

    # List of compatible swap schemes under different constraints
    same_row = [[-1 1; -1 1], [-1 1; 0 0], [-1 1; 1 -1], [0 0; -1 1], [0 0; 1 -1], [1 -1; -1 1], [1 -1; 0 0], [1 -1; 1 -1],]
    same_col = [[-1 -1; 1 1], [-1 0; 1 0], [-1 1; 1 -1], [0 -1; 0 1], [0 1; 0 -1], [1 -1; -1 1], [1 0; -1 0], [1 1; -1 -1],]
    same_all = filter(x -> x ∈ same_row, same_col)
    same_lnk = unique(vcat(same_row, same_col))

    # Pick the correcty matrix series
    m = same_lnk
    constraint == :degree && (m = same_all)
    constraint == :vulnerability && (m = same_col)
    constraint == :generality && (m = same_row)

    permuted = false
    while !permuted
        s1 = rand(1:richness(N; dims=1), 2)
        s2 = rand(1:richness(N; dims=2), 2)
        while !quanti_shuffle_valid(N.A, s1, s2)
            s1 = rand(1:richness(N; dims=1), 2)
            s2 = rand(1:richness(N; dims=2), 2)
        end
        st1 = filter(a -> all(first(lims).<=a.<=last(lims)), [N[s1,s2] .+ x for x in m])
        st2 = filter(a -> all((N[s1,s2].!=0).==(a.!=0)), st1)
        if length(st2) > 0
            permuted = true
            k = rand(st2)
            for i in 1:2, j in 1:2
                N[s1[i],s2[j]] = k[i,j]
            end
        end
    end

end

function shuffle!(N::BipartiteQuantitativeNetwork{Float64,K}; ε::Float64=1e-2, constraint::Symbol=:degree, lims=(0.0, Inf)) where {K <: AllowedSpeciesTypes}
    constraint ∈ [:degree, :generality, :vulnerability, :fill] || throw(ArgumentError("The constraint argument you specificied ($(constraint)) is invalid -- see ?shuffle! for a list."))
    first(lims) < last(lims) || throw(ArgumentError("The interval you used for limits, $(lims), is invalid"))
    all(first(lims) .<= N.A .<= last(lims)) || throw(ArgumentError("The interval you used for limits, $(lims), is smaller than the range of network values"))

    # List of compatible swap schemes under different constraints
    same_row = [[-1 1; -1 1], [-1 1; 0 0], [-1 1; 1 -1], [0 0; -1 1], [0 0; 1 -1], [1 -1; -1 1], [1 -1; 0 0], [1 -1; 1 -1],]
    same_col = [[-1 -1; 1 1], [-1 0; 1 0], [-1 1; 1 -1], [0 -1; 0 1], [0 1; 0 -1], [1 -1; -1 1], [1 0; -1 0], [1 1; -1 -1],]
    same_all = filter(x -> x ∈ same_row, same_col)
    same_lnk = unique(vcat(same_row, same_col))

    # Pick the correcty matrix series
    m = same_lnk
    constraint == :degree && (m = same_all)
    constraint == :vulnerability && (m = same_col)
    constraint == :generality && (m = same_row)
    m = m.* ε

    permuted = false
    while !permuted
        s1 = rand(1:richness(N; dims=1), 2)
        s2 = rand(1:richness(N; dims=2), 2)
        while !quanti_shuffle_valid(N.A, s1, s2)
            s1 = rand(1:richness(N; dims=1), 2)
            s2 = rand(1:richness(N; dims=2), 2)
        end
        st1 = filter(a -> all(first(lims).<=a.<=last(lims)), [N[s1,s2] .+ x for x in m])
        st2 = filter(a -> all((N[s1,s2].!=0).==(a.!=0)), st1)
        if length(st2) > 0
            permuted = true
            k = rand(st2)
            for i in 1:2, j in 1:2
                N[s1[i],s2[j]] = k[i,j]
            end
        end
    end
end

K = BipartiteQuantitativeNetwork(N.A./maximum(N.A), EcologicalNetworks.species_objects(N)...)
L = copy(K)
@progress for i in 1:2000
    shuffle!(K; constraint=:degree, ε=1e-4, lims=(0.0, 1.0))
    @info "$(lpad(string(i), 4))\tΔ: $(nodf(K)-nodf(L))"
end
