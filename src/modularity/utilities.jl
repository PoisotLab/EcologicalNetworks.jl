function δ(N::T, L::Dict{E,Int64}) where {T<:AbstractEcologicalNetwork,E}
    for s in species(N)
        @assert haskey(L, s)
    end

    this_l = filter(p -> p.first in species(N), L)
    tl = [this_l[s] for s in species(N; dims=1)]
    bl = [this_l[s] for s in species(N; dims=2)]
    D = tl .== bl'
    return D
end

"""
    Q(N::T, L::Dict{E,Int64}) where {T<:AbstractEcologicalNetwork,E}

Modularity of a network and its partition. The second argument is a dictionary
where every species of `N` is associated to an `Int64` value representing the
identity of the module. This function returns the same value of bipartite
networks and their unipartite projection.

#### References

Barber, M.J., 2007. Modularity and community detection in bipartite networks.
Phys. Rev. E 76, 066102. https://doi.org/10.1103/PhysRevE.76.066102

Newman, M.E., 2006. Modularity and community structure in networks. Proceedings
of the national academy of sciences 103, 8577–8582.
"""
function Q(N::T, L::Dict{E,Int64}) where {T<:AbstractEcologicalNetwork,E}
    for s in species(N)
        @assert haskey(L, s)
    end

    # Degrees
    dkin, dkout = degree_in(N), degree_out(N)
    kin = map(x -> dkin[x], species(N; dims=2))
    kout = map(x -> dkout[x], species(N; dims=1))

    # Value of m -- sum of weights, total number of int, ...
    m = links(N)

    # Null model
    kikj = (kout .* kin')
    Pij = kikj ./ m

    # Difference
    diff = N.A .- Pij

    # Diff × delta
    dd = diff .* δ(N,L)

    return sum(dd)/m
end

"""
    Qr(N::T, L::Dict{E,Int64}) where {T<:AbstractEcologicalNetwork,E}

Realized modularity -- this function returns a value giving the proportion of
all links that are within the same module. Higher values reflect a more strongly
modular partition (whereas `Q` represents the deviation of modularity from the
random expectation).

#### References

Poisot, T., 2013. An a posteriori measure of network modularity. F1000Research
2. https://doi.org/10.12688/f1000research.2-130.v3
"""
function Qr(N::T, L::Dict{E,Int64}) where {T<:AbstractEcologicalNetwork,E}
    for s in species(N)
        @assert haskey(L, s)
    end
    W = sum(N.A .* δ(N, L))
    B = links(N)
    return 2.0 * (W/B) - 1.0
end

function tidy_modules!(L::Dict{E,Int64}) where {E}
  l_values = sort(unique(collect(values(L))))
  for i in 1:length(l_values)
    for (k,v) in L
      if v == l_values[i]
        L[k] = i
      end
    end
  end
end
