"""
    flow_diversity(N::T; dims::Integer=1) where {T <: UnipartiteQuantitativeNetwork}

TODO

#### References

Bersier, L.F., Banašek-Richter, C., Cattin, M.-F., 2002. Quantitative
descriptors of food-web matrices. Ecology 83, 2394–2407.
"""
function flow_diversity(N::T; dims::Integer=1) where {T <: UnipartiteQuantitativeNetwork}
    @assert dims ∈ [1,2]
    @warn "UNTESTED"
    b = N.A / sum(N; dims=dims)
    bsum = sum(b; dims=dims)
    return -sum(bsum .* log.(2.0, bsum))
end

"""
    equivalent_degree(N::T; dims::Integer=1) where {T <: UnipartiteQuantitativeNetwork}

TODO

#### References

Bersier, L.F., Banašek-Richter, C., Cattin, M.-F., 2002. Quantitative
descriptors of food-web matrices. Ecology 83, 2394–2407.
"""
function equivalent_degree(N::T; dims::Integer=1) where {T <: UnipartiteQuantitativeNetwork}
end
