mutable struct KN{IT<:AbstractFloat, ST}
    edges::SparseMatrixCSC{IT}
    S::Vector{ST}
    function KN(edges::M, S::Vector{ST}) where {M <: SparseMatrixCSC{<:Number, Int64}, ST}
        @info "inner"
        EcologicalNetworks.check_probability_values(edges)
        return new{eltype(edges),ST}(edges, S)
    end
end

KN(y, [1,2,3])

KN(sparse(rand(Float16, (3, 2))), [1 ,2, 3, 4])

function KN(edges::M, S::Vector{ST}) where {M <: SparseMatrixCSC{Float64, Int64}, ST}
    EcologicalNetworks.check_probability_values(edges)
    return KN{eltype(edges),ST}(edges, S)
end
