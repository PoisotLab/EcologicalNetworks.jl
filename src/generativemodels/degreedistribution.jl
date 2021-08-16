"""
    DegreeDistributionModel
"""
mutable struct DegreeDistributionModel{IT <: Integer, DT <: Distribution} <: NetworkGenerator
    size::Tuple{IT,IT}
    dist::DT
end

# TODO assert in constructor that dist returns values on the natural numbers 

"""
    bipartite_degreedist(T,B,λ)

    Generates a bipartite network with `T` and `B` nodes in each
    partition, and draws the degree of each node in `T` from a Poisson
    distribution with mean `λ`. As T,B -> infinity, 
    the degree dist of T and B converge.
"""
function bipartite_degreedist(T::IT, B::IT, C::FT) where {IT <: Integer, FT <: AbstractFloat}
    totaledges = C*(T*B)
    λ = totaledges/(T+B)
    return bipartite_degreedist(T, B; λ=λ)
end

function bipartite_degreedist(T::IT, B::IT; λ::FT = 3) where {IT <: Integer, FT <: AbstractFloat}
    adjacency_matrix = zeros(Bool, T,B);

    for t in 1:T
        k_t = min(rand(Poisson(λ)), T)  
        attach = sample(collect(1:B), k_t, replace=false)
        for b in attach 
            adjacency_matrix[t,b] = 1
        end
    end
    return BipartiteNetwork(adjacency_matrix)
end
