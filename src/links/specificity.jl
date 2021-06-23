
"""
    pdi{T<:Number}(x::Array{T, 1})

This function will range the values of each row, so that the strongest link has
a value of one. This works for deterministic and quantitative networks.

#### References

Poisot, T., Bever, J.D., Nemri, A., Thrall, P.H., Hochberg, M.E., 2011. A
conceptual framework for the evolution of ecological specialisation. Ecol. Lett.
14, 841–851. https://doi.org/10.1111/j.1461-0248.2011.01645.x

Poisot, T., Canard, E., Mouquet, N., Hochberg, M.E., 2012. A comparative study
of ecological specialization estimators. Methods in Ecology and Evolution 3,
537–544. https://doi.org/10.1111/j.2041-210X.2011.00174.x
"""
function pdi(x::T) where {T<:AbstractArray{<:Number}}
    dp = (1.0 .- sort(x/maximum(x), rev=true))[2:end]
    return sum(dp)/(length(x)-1)
end

"""
    specificity(N::DeterministicNetwork)

Measure of specificity in a deterministic network. This returns a value between
0 and 1, where 1 indicates maximal specificity.

#### References

- Poisot, T., Bever, J.D., Nemri, A., Thrall, P.H., Hochberg, M.E., 2011. A
  conceptual framework for the evolution of ecological specialisation. Ecol.
  Lett. 14, 841–851. https://doi.org/10.1111/j.1461-0248.2011.01645.x

- Poisot, T., Canard, E., Mouquet, N., Hochberg, M.E., 2012. A comparative study
  of ecological specialization estimators. Methods in Ecology and Evolution 3,
  537–544. https://doi.org/10.1111/j.2041-210X.2011.00174.x
"""
function specificity(N::DeterministicNetwork)
    return Dict([s => pdi(N[i,:]) for (i,s) in enumerate(species(N; dims=1))])
end