"""
    linearfilter(N::BinaryNetwork, α::Vector{Float64}=[0.25, 0.25, 0.25, 0.25])

Given a network `N` compute the linear filter scores according to Stock et al.
(2017). High scores for negative interactions indicate potential false negative
or missing interactions. Though this it returned as a probabilistic network,
score do not necessary convey a probabilistic interpretation.

The values of α give the *relative* weight of, in order, the measured
interaction value, the out-degree of the species, the in-degree of the species,
and of network connectance. The default parameterization is to have all four at
equal importance.

#### References

Stock, M., Pahikkala, T., Airola, A., Waegeman, W., Baets, B.D., 2018. Algebraic
Shortcuts for Leave-One-Out Cross-Validation in Supervised Network Inference.
bioRxiv 242321. https://doi.org/10.1101/242321

Stock, M., Poisot, T., Waegeman, W., Baets, B.D., 2017. Linear filtering reveals
false negatives in species interaction data. Scientific Reports 7, 45908.
https://doi.org/10.1038/srep45908
"""
function linearfilter(N::T; α::Vector{Float64}=fill(1.0, 4)) where {T <: BinaryNetwork}
    @assert length(α) == 4
    @assert all(α .≥ 0.0)
    α = α ./ sum(α) # This ensures that α sums to 1.0
    
    # Get the new weights
    W = α[1]A.edges .+ α[2]mean(A.edges; dims=2) .+ α[3]mean(A.edges; dims=1) .+ α[4]mean(A.edges)
    
    # Prepare a return object
    return_type = T <: AbstractBipartiteNetwork ? BipartiteProbabilisticNetwork : UnipartiteProbabilisticNetwork
    F = return_type(W, EcologicalNetworks._species_objects(N)...)
    
    return W
end

"""
    linearfilterzoo(N::BinaryNetwork, α::Vector{Float64}=[0.25, 0.25, 0.25, 0.25])

Compute the zero-one-out version of the linear filter (`linearfilter`), i.e.
the score for each interaction if that interaction would not occur in the network.
For example, if N[4, 6] = 1 (interaction between species 4 and 6), the result at
postion (4, 6) is the score of the filter using a network in which that interaction
did not occur. This function is useful for validating the filter whether it can
detect false negative (missing) interactions.

#### References

Stock, M., Pahikkala, T., Airola, A., Waegeman, W., Baets, B.D., 2018. Algebraic
Shortcuts for Leave-One-Out Cross-Validation in Supervised Network Inference.
bioRxiv 242321. https://doi.org/10.1101/242321

Stock, M., Poisot, T., Waegeman, W., Baets, B.D., 2017. Linear filtering reveals
false negatives in species interaction data. Scientific Reports 7, 45908.
https://doi.org/10.1038/srep45908
"""
function linearfilterzoo(N::T; α::Vector{Float64}=fill(0.25, 4)) where {T <: BinaryNetwork}
    F = linearfilter(N, α=α)  # depart from scores of the filter
    Fzoo = F  # update the values to zero-one-out scores, reference is to keep
    # the code readable
    
    # Get the size of the network
    n = richness(N; dims=1)
    m = richness(N; dims=2)
    # Get probabilities
    for s1 in species(N; dims=1)
        for s2 in species(N; dims=2)
            t_val = F[s1,s2] - (α[1] + (α[2] / m) + (α[3] / n) + α[4] / (n * m)) * N[s1,s2]
            Fzoo[s1,s2] = max(min(t_val, one(t_val)), zero(t_val))
        end
    end
    
    return Fzoo
end
