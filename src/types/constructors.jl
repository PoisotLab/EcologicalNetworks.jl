function UnipartiteNetwork(A::M) where {M<:AbstractMatrix{Bool}}
  check_unipartiteness(A)
  S = "s".*string.(1:size(A,1))
  UnipartiteNetwork(A, S)
end

function UnipartiteNetwork(A::M, S::Vector{NT}) where {M<:AbstractMatrix{Bool}, NT <: AllowedSpeciesTypes}
  check_unipartiteness(A, S)
  UnipartiteNetwork{NT}(A, S)
end


function BipartiteNetwork(A::M) where {M<:AbstractMatrix{Bool}}
  check_bipartiteness(A)
  T = "t".*string.(1:size(A,1))
  B = "b".*string.(1:size(A,2))
  BipartiteNetwork{eltype(T)}(A, T, B)
end

function BipartiteNetwork(A::M, T::Vector{NT}, B::Vector{NT}) where {M<:AbstractMatrix{Bool}, NT<:AllowedSpeciesTypes}
  check_bipartiteness(A, T, B)
  BipartiteNetwork{eltype(T)}(A, T, B)
end

function BipartiteProbabilisticNetwork(A::Matrix{IT}) where {IT<:AbstractFloat}
  check_bipartiteness(A)
  check_probability_values(A)
  T = "t".*string.(1:size(A,1))
  B = "b".*string.(1:size(A,2))
  BipartiteProbabilisticNetwork{IT,eltype(T)}(A, T, B)
end

function BipartiteProbabilisticNetwork(A::Matrix{IT}, T::Vector{NT}, B::Vector{NT}) where {IT<:AbstractFloat, NT<:AllowedSpeciesTypes}
  check_bipartiteness(A, T, B)
  check_probability_values(A)
  BipartiteProbabilisticNetwork{IT,NT}(A, T, B)
end

function BipartiteQuantitativeNetwork(A::Matrix{IT}) where {IT <: Number}
  check_bipartiteness(A)
  T = "t".*string.(1:size(A,1))
  B = "b".*string.(1:size(A,2))
  BipartiteQuantitativeNetwork{IT,eltype(T)}(A, T, B)
end

function BipartiteQuantitativeNetwork(A::Matrix{IT}, T::Vector{NT}, B::Vector{NT}) where {IT<:Number, NT<:AllowedSpeciesTypes}
  check_bipartiteness(A, T, B)
  BipartiteQuantitativeNetwork{IT,NT}(A, T, B)
end

function UnipartiteQuantitativeNetwork(A::Matrix{IT}) where {IT<:Number}
  check_unipartiteness(A)
  S = "s".*string.(1:size(A,1))
  UnipartiteQuantitativeNetwork{IT,eltype(S)}(A, S)
end

function UnipartiteQuantitativeNetwork(A::Matrix{IT}, S::Vector{NT}) where {IT<:Number,NT<:AllowedSpeciesTypes}
  check_unipartiteness(A, S)
  UnipartiteQuantitativeNetwork{IT,NT}(A, S)
end



function UnipartiteProbabilisticNetwork(A::Matrix{IT}) where {IT<:AbstractFloat}
  check_unipartiteness(A)
  check_probability_values(A)
  S = "s".*string.(1:size(A,1))
  UnipartiteProbabilisticNetwork{IT,eltype(S)}(A, S)
end

function UnipartiteProbabilisticNetwork(A::Matrix{IT}, S::Vector{NT}) where {IT<:AbstractFloat,NT<:AllowedSpeciesTypes}
  check_unipartiteness(A, S)
  check_probability_values(A)
  UnipartiteProbabilisticNetwork{IT,NT}(A, S)
end
