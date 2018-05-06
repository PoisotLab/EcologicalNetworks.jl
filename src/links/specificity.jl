
"""
**Paired Differences Index**

    pdi{T<:Number}(x::Array{T, 1})

This function will range the values of each row, so that the strongest link has
a value of one. This works for deterministic and quantitative networks.

```jldoctest
julia> EcologicalNetwork.pdi(vec([1.0 0.0 0.0]))
1.0

julia> EcologicalNetwork.pdi(vec([0.0 0.0 1.0]))
1.0

julia> EcologicalNetwork.pdi(vec([1.0 1.0 1.0]))
0.0
```

> Poisot, T., Canard, E., Mouquet, N., Hochberg, M.E., 2012. A comparative study
> of ecological specialization estimators. Methods in Ecology and Evolution 3,
> 537–544. doi:10.1111/j.2041-210X.2011.00174.x

"""
function pdi{T<:Number}(x::Array{T, 1})
    s = reverse(sort(x))
    s = s ./ maximum(s)
    p = s[1] .- s
    return sum(p[2:end])/(length(s)-1)
end


"""
**Resource range**

    specificity(N::DeterministicNetwork)

Measure of specificity in a deterministic network. This returns a value between
0 and 1, where 1 indicates maximal specificity.

```jldoctest
julia> N = BipartiteNetwork(eye(Bool, 10));

julia> specificity(N)[1]
1.0
```

> Poisot, T., Canard, E., Mouquet, N., Hochberg, M.E., 2012. A comparative study
> of ecological specialization estimators. Methods in Ecology and Evolution 3,
> 537–544. doi:10.1111/j.2041-210X.2011.00174.x

"""
function specificity(N::BinaryNetwork)
    A = map(Int64, N.A)
    return Dict(zip(species(N,1), vec(mapslices(pdi, A, 2))))
end

"""
**Paired Differences Index**

    specificity(N::QuantitativeNetwork)

Measure of specificity in a quantitative network. This returns a value between 0
and 1, where 1 indicates maximal specificity. Note that the PDI is measured
species-wise, and the maximal interaction strength of every species is set to 1.

```jldoctest
julia> N = BipartiteNetwork(eye(Int64, 10));

julia> specificity(N)[1]
1.0
```
> Poisot, T., Canard, E., Mouquet, N., Hochberg, M.E., 2012. A comparative study
> of ecological specialization estimators. Methods in Ecology and Evolution 3,
> 537–544. doi:10.1111/j.2041-210X.2011.00174.x

"""
function specificity(N::QuantitativeNetwork)
    return Dict(zip(species(N,1), vec(mapslices(pdi, N.A, 2))))
end
