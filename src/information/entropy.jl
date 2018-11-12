
# safe log(x) function, log 0 = 0
safelog(x) = x > zero(x) ? log2(x) : zero(x)
safediv(x, y) = y == zero(y) ? zero(y) : x / y
# general functions for entropy


"""
    make_joint_distribution(N::NT) where {NT<:AbstractEcologicalNetwork}

Returns a double stochastic matrix from the adjacency or incidence matrix.
Raises an error if the matrix contains negative values.
"""
function make_joint_distribution(N::NT) where {NT<:AbstractEcologicalNetwork}
    (typeof(N) <: QuantitativeNetwork) ⊻ any(N.A .≥ 0) || throw(DomainError("Information only for nonnegative interaction values"))
    return N.A / sum(N.A)
end

function entropy(P::AbstractArray)
    return - sum(P .* safelog.(P))
end

function entropy(P::AbstractArray, dims::I) where I <: Int
    return entropy(sum(P', dims=dims))
end

function entropy(N::NT) where {NT<:AbstractEcologicalNetwork}
    P = make_joint_distribution(N)
    return entropy(P)
end

function entropy(N::NT, dims::I) where {NT<:AbstractEcologicalNetwork, I <: Int}
    P = make_joint_distribution(N)
    return entropy(P, dims)
end

function conditional_entropy(P::AbstractArray, given::I) where I <: Int
    dims = (given % 2) + 1
    return - sum(P .* safelog.(safediv.(P, sum(P, dims=dims))))
end

function conditional_entropy(N::NT, given::I) where {NT<:AbstractEcologicalNetwork, I <: Int}
    P = make_joint_distribution(N)
    return conditional_entropy(P, given)
end

function mutual_information(P::AbstractArray)
    I = entropy(P, 1) - conditionalentropy(P, 2)
    return max(I, zero(I))  # might give small negative value
end

function mutual_information(N::NT) where {NT<:AbstractEcologicalNetwork}
    P = make_joint_distribution(N)
    return mutual_information(P)
end

function variation_information(P::AbstractArray)
    return conditional_entropy(P, 1) + conditionalentropy(P, 2)
end

function variation_information(N::NT) where {NT <: AbstractEcologicalNetwork}
    P = make_joint_distribution(N)
    return variation_information(P)
end

function diff_entropy_uniform(P::AbstractArray)
    return log2(length(P)) - entropy(P, 1) - entropy(P, 2)
end

function diff_entropy_uniform(P::AbstractArray, dims::I) where {I <: Int}
    return log2(size(P, dims)) - entropy(P, dims)
end

function diff_entropy_uniform(N::NT, dims=nothing) where {NT <: AbstractEcologicalNetwork}
    if dims == nothing
        P = make_joint_distribution(N)
        return diff_entropy_uniform(P)
    else  # compute marginals
        typeof(dims) <: Int || throw(ArgumentError("dims should be an integer (1 or 2)"))
        P = make_joint_distribution(N)
        return diff_entropy_uniform(P, dims)
    end
end

function information_decomposition(N::NT; norm::Bool=false, dims::I=nothing) where {NT <: AbstractEcologicalNetwork, I <: Union{Int, Nothing}}
    decomposition = Dict{Symbol, Float64}()
    P = make_joint_distribution(N)
    if dims == nothing
        # difference marginal entropy
        decomposition[:D] = diff_entropy_uniform(P)
        # mutual information
        decomposition[:I] = 2mutual_information(P)
        # variance of information
        decomposition[:V] = variation_information(P)
    else
        decomposition[:D] = diff_entropy_uniform(P, dims)
        decomposition[:I] = mutual_information(P)
        decomposition[:V] = conditional_entropy(P, (dims % 2) + 1)
    end
    if norm
        potential_information = sum(values(decomposition))
        for key in keys(decomposition)
            decomposition[key] /= potential_information
        end
    end
    return decomposition
end

function convert2effective(indice::F) where F <: Float
    return 2.0^indice
end 
