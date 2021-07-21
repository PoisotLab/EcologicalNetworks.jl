using LinearAlgebra: lmul!, rmul!, Diagonal

"""
    optimaltransportation(M::AbstractArray;
            [a, b, λ=1, ϵ=1e-10, maxiter=100])

Performs optimal transportation on an ecological network. Here, `M` is treated
as an utility matrix, quantifying the preference the species of the two throphic
levels have for interacting with another. One can fix both, one or none of the
species abundances by given `a` (row sums, corresponding to top species) and/or
`b` (column sums, corresponding to bottom species). The strengh of entropic 
regularisation is set by `λ`, where higher values indicate more utitlity and lower
values more entropy. 

ϵ and `maxiter` control the number of Sinkhorn iterations. You likely won't need
to change these.

This version works on arrays.

Stock, M., Poisot, T., & De Baets, B. (2021). « Optimal transportation theory for
species interaction networks. » Ecology and Evolution, 00(1), ece3.7254.
https://doi.org/10.1002/ece3.7254
"""
function optimaltransportation(M::AbstractArray;
        a=nothing, b=nothing, λ::Number=1, ϵ=1e-10, maxiter=100)
    Q = ot(M, a, b; λ=λ, ϵ=ϵ, maxiter=maxiter)
    return Q
end

"""
    optimaltransportation(M::AbstractBipartiteNetwork;
            [a, b, λ=1, ϵ=1e-10, maxiter=100])

Performs optimal transportation on an ecological network. Here, `M` is treated
as an utility matrix, quantifying the preference the species of the two throphic
levels have for interacting with another. One can fix both, one or none of the
species abundances by given `a` (row sums, corresponding to top species) and/or
`b` (column sums, corresponding to bottom species). The strengh of entropic 
regularisation is set by `λ`, where higher values indicate more utitlity and lower
values more entropy. 

ϵ and `maxiter` control the number of Sinkhorn iterations. You likely won't need
to change these.

Stock, M., Poisot, T., & De Baets, B. (2021). « Optimal transportation theory for
species interaction networks. » Ecology and Evolution, 00(1), ece3.7254.
https://doi.org/10.1002/ece3.7254
"""
function optimaltransportation(M::AbstractBipartiteNetwork;
    a=nothing, b=nothing, λ::Number=1, ϵ=1e-10, maxiter=100)
    Q = ot(M.edges, a, b; λ=λ, ϵ=ϵ, maxiter=maxiter)
    return BipartiteQuantitativeNetwork(Q, species(M, dims=1), species(M, dims=2))
end


# optimal transportation fixing both marginals
function ot(M::AbstractMatrix, a::AbstractVector, b::AbstractVector; λ, ϵ, maxiter)
    @assert size(M) == (length(a), length(b))
    @assert all(a .> 0) "all values of `a` have to be greater than 0"
    @assert all(b .> 0) "all values of `b` have to be greater than 0"
    @assert sum(a) ≈ sum(b) "`a` and `b` have to have the same sums"
    Q = exp.(λ * M)
    iter = 0
    for iter in 1:maxiter
        iter += 1
        lmul!(Diagonal(a ./ sum(Q, dims=2)[:]), Q)  # normalize rows
        rmul!(Q, Diagonal(b ./ sum(Q, dims=1)[:]))  # normalize columns
        maximum(abs.(sum(Q, dims=2)[:] - a)) < ϵ && break
    end
    return Q
end

# optimal transportation fixing a
function ot(M::AbstractMatrix, a::AbstractVector, b::Nothing; λ, ϵ, maxiter)
    @assert size(M, 1) == length(a) && all(a .> 0)
    Q = exp.(λ * M)
    lmul!(Diagonal(a ./ sum(Q, dims=2)[:]), Q)
    return Q
end

# optimal transportation fixing b
function ot(M::AbstractMatrix, a::Nothing, b::AbstractVector; λ, ϵ, maxiter)
    @assert size(M, 2) == length(b) && all(b .> 0)
    Q = exp.(λ * M)
    rmul!(Q, Diagonal(b ./ sum(Q, dims=1)[:]))
    return Q
end

# optimal transportation free
function ot(M::AbstractMatrix, a::Nothing, b::Nothing; λ, ϵ, maxiter)
    Q = exp.(λ * M)
    Q ./= sum(Q)
    return Q
end