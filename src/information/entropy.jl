using Base: Integer

# safe log(x) function, log 0 = 0
safelog(x) = x > zero(x) ? log2(x) : zero(x)
safediv(x, y) = y == zero(y) ? zero(y) : x / y
# general functions for entropy


"""
    make_joint_distribution(N::NT) where {NT<:AbstractEcologicalNetwork}

Returns a probability matrix computed from the adjacency or incidence matrix.
Raises an error if the matrix contains negative values. Output in bits.
"""
function make_joint_distribution(N::NT) where {NT<:AbstractEcologicalNetwork}
    !(typeof(N) <: QuantitativeNetwork) || any(N.edges .≥ 0) || throw(DomainError("Information only for nonnegative interaction values"))
    return N.edges / sum(N.edges)
end

"""
    entropy(P::AbstractArray; [dims])

Computes the joint entropy of a probability matrix. Does not perform any
checks whether the matrix is normalized. Output in bits.

If the `dims` keyword argument is provided, the marginal entropy of the matrix
is computed. `dims` indicates whether to compute the entropy for the rows 
(`dims=1`) or columns (`dims=2`).
"""
function entropy(P::AbstractArray; dims::Union{Integer,Nothing}=nothing)
    isnothing(dims) && return - sum(P .* safelog.(P))
    return entropy(sum(P', dims=dims))
end

"""
    entropy(N::AbstractEcologicalNetwork)


"""
function entropy(N::NT) where {NT<:AbstractEcologicalNetwork}
    P = make_joint_distribution(N)
    return entropy(P)
end

"""
    entropy(N::AbstractEcologicalNetwork; [dims])

Computes the joint entropy of an ecological network. If `dims` is specified,
The marginal entropy of the ecological network is computed. `dims` indicates
whether to compute the entropy for the rows (`dims=1`) or columns (`dims=2`).
Output in bits.
"""
function entropy(N::NT; dims::Union{Integer,Nothing}=nothing) where {NT<:AbstractEcologicalNetwork}
    P = make_joint_distribution(N)
    return entropy(P; dims)
end

"""
    conditional_entropy(P::AbstractArray, given::I)

Computes the conditional entropy of probability matrix. If `given = 1`,
it is the entropy of the columns, and vise versa when `given = 2`. Output in bits.

Does not check whether `P` is a valid probability matrix.
"""
function conditional_entropy(P::AbstractArray, given::Integer)
    dims = (given % 2) + 1
    return - sum(P .* safelog.(safediv.(P, sum(P; dims=dims))))
end

"""
    conditional_entropy(N::AbstractEcologicalNetwork, given::I)

Computes the conditional entropy of an ecological network. If `given = 1`,
it is the entropy of the columns, and vise versa when `given = 2`.
"""
function conditional_entropy(N::NT, given::I) where {NT<:AbstractEcologicalNetwork, I <: Int}
    P = make_joint_distribution(N)
    return conditional_entropy(P, given)
end

"""
    mutual_information(P::AbstractArray)

Computes the mutual information of a probability matrix. Output in bits.
"""
function mutual_information(P::AbstractArray)
    I = entropy(P, dims=1) - conditional_entropy(P, 2)
    return max(I, zero(I))  # might give small negative value
end

"""
    mutual_information(N::NT) where {NT<:AbstractEcologicalNetwork}

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
    diff_entropy_uniform(P::AbstractArray; [dims])

Computes the difference in entropy of the marginals compared to the entropy of
an uniform distribution. The parameter `dims` indicates which marginals are used,
with both if no value is provided. Output in bits.
"""
function diff_entropy_uniform(P::AbstractArray; dims::Union{Integer,Nothing}=nothing)
    if isnothing(dims)
        D = log2(length(P)) - entropy(P, dims=1) - entropy(P, dims=2)
    else
        D = log2(size(P, dims)) - entropy(P; dims)
    end
    return max(zero(D), D)
end

"""
    diff_entropy_uniform(N::AbstractEcologicalNetwork, dims::I=nothing)

Computes the difference in entropy of the marginals compared to the entropy of
an uniform distribution. The parameter `dims` indicates which marginals are used,
with both if no value is provided. Output in bits.
"""
function diff_entropy_uniform(N::NT; dims::Union{Integer,Nothing}=nothing) where {NT <: AbstractEcologicalNetwork}
    P = make_joint_distribution(N)
    return diff_entropy_uniform(P; dims=dims)
end

"""
    information_decomposition(N::AbstractEcologicalNetwork; norm::Bool=false, dims=nothing)

Performs an information theory decomposition of a given ecological network, i.e.
the information content in the normalized adjacency matrix is split in:

- `:D` : difference in entropy of marginals compared to an uniform distribition
- `:I` : mutual information
- `:V` : variation of information / conditional entropy

If `norm=true`, the components are normalized such that their sum is equal to 1.
One can optinally give the dimision, indicating whether to compute the indices
for the rows (`dims=1`), columns (`dims=2`) or the whole matrix (default).

Result is returned in a Dict. Outputs in bits.

Stock, M.; Hoebeke, L.; De Baets, B. « Disentangling the Information in Species Interaction Networks ».
Entropy 2021, 23, 703. https://doi.org/10.3390/e23060703
"""
function information_decomposition(N::NT; norm::Bool=false, dims::Union{Integer,Nothing}=nothing) where {NT <: AbstractEcologicalNetwork}
    decomposition = Dict{Symbol, Float64}()
    P = make_joint_distribution(N)
    if isnothing(dims)
        # difference marginal entropy
        decomposition[:D] = diff_entropy_uniform(P)
        # mutual information
        decomposition[:I] = 2mutual_information(P)
        # variance of information
        decomposition[:V] = variation_information(P)
    else
        decomposition[:D] = diff_entropy_uniform(P; dims=dims)
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
corresponding interactions). Assumes an input in bits (i.e. log with base 2 is used).
"""
function convert2effective(indice::R) where R <: Real
    return 2.0^indice
end

"""
    potential_information(N::NT; [dims])

Computes the maximal potential information in a network, corresponding to
every species interacting with every other species. Compute result for the
marginals using the optional parameter `dims`. Output in bits.
"""
function potential_information(N::NT; dims::Union{Integer,Nothing}=nothing) where {NT <: AbstractEcologicalNetwork}
    n, m = size(N)
    isnothing(dims) && return log2(n) + log2(m)
    dims == 1 && return log2(n) 
    dims == 2 && return log2(m)
end
