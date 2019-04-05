
# safe log(x) function, log 0 = 0
safelog(x) = x > zero(x) ? log2(x) : zero(x)
safediv(x, y) = y == zero(y) ? zero(y) : x / y
# general functions for entropy


"""
    make_joint_distribution(N::NT) where {NT<:AbstractEcologicalNetwork}

Returns a double stochastic matrix from the adjacency or incidence matrix.
Raises an error if the matrix contains negative values. Output in bits.
"""
function make_joint_distribution(N::NT) where {NT<:AbstractEcologicalNetwork}
    !(typeof(N) <: QuantitativeNetwork) || any(N.A .≥ 0) || throw(DomainError("Information only for nonnegative interaction values"))
    return N.A / sum(N.A)
end

"""
   entropy(P::AbstractArray)

Computes the joint entropy of a double stochastic matrix. Does not perform any
checks whether the matrix is normalized. Output in bits.
"""
function entropy(P::AbstractArray)
    return - sum(P .* safelog.(P))
end

"""
   entropy(P::AbstractArray, dims::I)

Computes the marginal entropy of a double stochastic matrix. `dims` indicates
whether to compute the entropy for the rows (`dims`=1) or columns (`dims`=2).
Does not perform any checks whether the matrix is normalized. Output in bits.
"""
function entropy(P::AbstractArray, dims::I) where I <: Int
    return entropy(sum(P', dims=dims))
end

"""
   entropy(N::AbstractEcologicalNetwork)

Computes the joint entropy of an ecological network. Output in bits.
"""
function entropy(N::NT) where {NT<:AbstractEcologicalNetwork}
    P = make_joint_distribution(N)
    return entropy(P)
end

"""
   entropy(N::AbstractEcologicalNetwork, dims::I)

Computes the marginal entropy of an ecological network. `dims` indicates
whether to compute the entropy for the rows (`dims`=1) or columns (`dims`=2).
Output in bits.
"""
function entropy(N::NT, dims::I) where {NT<:AbstractEcologicalNetwork, I <: Int}
    P = make_joint_distribution(N)
    return entropy(P, dims)
end

"""
   conditional_entropy(P::AbstractArray, given::I)

Computes the conditional entropy of double stochastic matrix. If `given = 1`,
it is the entropy of the columns, and visa versa when `given = 2`. Output in bits.
"""
function conditional_entropy(P::AbstractArray, given::I) where I <: Int
    dims = (given % 2) + 1
    return - sum(P .* safelog.(safediv.(P, sum(P, dims=dims))))
end

"""
   conditional_entropy(N::AbstractEcologicalNetwork, given::I)

Computes the conditional entropy of an ecological network. If `given = 1`,
it is the entropy of the columns, and visa versa when `given = 2`.
"""
function conditional_entropy(N::NT, given::I) where {NT<:AbstractEcologicalNetwork, I <: Int}
    P = make_joint_distribution(N)
    return conditional_entropy(P, given)
end

"""
    mutual_information(P::AbstractArray)

Computes the mutual information of a double stochastic matrix. Output in bits.
"""
function mutual_information(P::AbstractArray)
    I = entropy(P, 1) - conditional_entropy(P, 2)
    return max(I, zero(I))  # might give small negative value
end

"""
    mutual_information(P::AbstractArray)

Computes the mutual information of an ecological network. Output in bits.
"""
function mutual_information(N::NT) where {NT<:AbstractEcologicalNetwork}
    P = make_joint_distribution(N)
    return mutual_information(P)
end

"""
    variation_information(P::AbstractArray)

Computes the variation of information of a double stochastic matrix. Output in
bits.
"""
function variation_information(P::AbstractArray)
    return conditional_entropy(P, 1) + conditional_entropy(P, 2)
end

"""
    variation_information(N::AbstractEcologicalNetwork)

Computes the variation of information of an ecological network. Output in
bits.
"""
function variation_information(N::NT) where {NT <: AbstractEcologicalNetwork}
    P = make_joint_distribution(N)
    return variation_information(P)
end

"""
    diff_entropy_uniform(P::AbstractArray)

Computes the difference in entropy of the marginals compared to the entropy of
an uniform distribution. The parameter `dims` indicates which marginals are used,
with both if no value is provided. Output in bits.
"""
function diff_entropy_uniform(P::AbstractArray)
    D = log2(length(P)) - entropy(P, 1) - entropy(P, 2)
    return max(zero(D), D)
end

"""
    diff_entropy_uniform(P::AbstractArray, dims::I)

Computes the difference in entropy of the marginals compared to the entropy of
an uniform distribution. The parameter `dims` indicates which marginals are used,
with both if no value is provided. Output in bits.
"""
function diff_entropy_uniform(P::AbstractArray, dims::I) where {I <: Int}
    D = log2(size(P, dims)) - entropy(P, dims)
    return max(zero(D), D)
end

"""
    diff_entropy_uniform(N::AbstractEcologicalNetwork, dims::I=nothing)

Computes the difference in entropy of the marginals compared to the entropy of
an uniform distribution. The parameter `dims` indicates which marginals are used,
with both if no value is provided. Output in bits.
"""
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

"""
    information_decomposition(N::AbstractEcologicalNetwork; norm::Bool=false, dims::I=nothing)

Performs an information theory decomposition of a given ecological network, i.e.
the information content in the normalized adjacency matrix is split in:

- `:D` : difference in entropy of marginals compared to an uniform distribition
- `:I` : mutual information
- `:V` : variation of information / conditional entropy

If `norm=true`, the components are normalized such that their sum is equal to 1.
One can optinally give the dimision, indicating whether to compute the indices
for the rows (`dims=1`), columns (`dims=2`) or the whole matrix (default).

Result is returned in a Dict. Outputs in bits.
"""
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

"""
    convert2effective(indice::Real)

Convert an information theory indices in an effective number (i.e. number of
corresponding interactions).
"""
function convert2effective(indice::R) where R <: Real
    return 2.0^indice
end

"""
    potential_information(N::NT)

Computes the maximal potential information in a network, corresponding to
every species interacting with every other species. Compute result for the
marginals using the optional parameter `dims`. Output in bits.
"""
function potential_information(N::NT) where NT <: AbstractEcologicalNetwork
    m, n = size(N)
    return log2(m) + log2(n)
end

"""
    potential_information(N::NT, dims::I)

Computes the maximal potential information in a network, corresponding to
every species interacting with every other species. Compute result for the
marginals using the optional parameter `dims`. Output in bits.
"""
function potential_information(N::NT, dims::I) where {NT <: AbstractEcologicalNetwork, I <: Int}
    return log2(size(N)[dims])
end
