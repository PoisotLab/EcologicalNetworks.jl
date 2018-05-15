function check_bipartiteness(A)
  return true
end

function check_unipartiteness(A)
  @assert size(A,1) == size(A,2)
end

function check_bipartiteness(A, T, B)
  check_bipartiteness(A)
  check_name_vector(T)
  check_name_vector(B)
  @assert eltype(T) == eltype(B)
  @assert length(unique(vcat(T,B))) == sum(size(A))
  @assert length(T) == size(A,1)
  @assert length(B) == size(A,2)
end

function check_unipartiteness(A, S)
  check_unipartiteness(A)
  check_name_vector(S)
  @assert length(S) == size(A,1)
end

function check_name_vector(N)
  @assert length(N) == length(unique(N))
end

function check_probability_values(A)
  @assert minimum(A) >= zero(eltype(A))
  @assert maximum(A) <= one(eltype(A))
end

function UnipartiteNetwork(A::AbstractMatrix{Bool})
  check_unipartiteness(A)
  S = "s".*string.(1:size(A,1))
  UnipartiteNetwork{eltype(S)}(A, S)
end

function UnipartiteNetwork{NT<:AllowedSpeciesTypes}(A::AbstractMatrix{Bool}, S::Array{NT,1})
  check_unipartiteness(A, S)
  UnipartiteNetwork{eltype(S)}(A, S)
end

function UnipartiteQuantitativeNetwork{IT<:Number}(A::Array{IT,2})
  check_unipartiteness(A)
  S = "s".*string.(1:size(A,1))
  UnipartiteQuantitativeNetwork{eltype(A),eltype(S)}(A, S)
end

function UnipartiteQuantitativeNetwork{IT<:Number,NT<:AllowedSpeciesTypes}(A::Array{IT,2}, S::Array{NT,1})
  check_unipartiteness(A, S)
  UnipartiteQuantitativeNetwork{eltype(A),eltype(S)}(A, S)
end

function UnipartiteProbabilisticNetwork{IT<:AbstractFloat}(A::Array{IT,2})
  check_unipartiteness(A)
  check_probability_values(A)
  S = "s".*string.(1:size(A,1))
  UnipartiteProbabilisticNetwork{eltype(A),eltype(S)}(A, S)
end

function UnipartiteProbabilisticNetwork{IT<:AbstractFloat,NT<:AllowedSpeciesTypes}(A::Array{IT,2}, S::Array{NT,1})
  check_unipartiteness(A, S)
  check_probability_values(A)
  UnipartiteProbabilisticNetwork{eltype(A),eltype(S)}(A, S)
end

function BipartiteNetwork(A::AbstractMatrix{Bool})
  check_bipartiteness(A)
  T = "t".*string.(1:size(A,1))
  B = "b".*string.(1:size(A,2))
  BipartiteNetwork{eltype(T)}(A, T, B)
end

function BipartiteNetwork{NT<:AllowedSpeciesTypes}(A::AbstractMatrix{Bool}, T::Array{NT,1}, B::Array{NT,1})
  check_bipartiteness(A, T, B)
  BipartiteNetwork{eltype(T)}(A, T, B)
end

function BipartiteQuantitativeNetwork{IT<:Number}(A::Array{IT,2})
  check_bipartiteness(A)
  T = "t".*string.(1:size(A,1))
  B = "b".*string.(1:size(A,2))
  BipartiteQuantitativeNetwork{eltype(A),eltype(T)}(A, T, B)
end

function BipartiteQuantitativeNetwork{IT<:Number,NT<:AllowedSpeciesTypes}(A::Array{IT,2}, T::Array{NT,1}, B::Array{NT,1})
  check_bipartiteness(A, T, B)
  BipartiteQuantitativeNetwork{eltype(A),eltype(T)}(A, T, B)
end

function BipartiteProbabilisticNetwork{IT<:AbstractFloat}(A::Array{IT,2})
  check_bipartiteness(A)
  check_probability_values(A)
  T = "t".*string.(1:size(A,1))
  B = "b".*string.(1:size(A,2))
  BipartiteProbabilisticNetwork{eltype(A),eltype(T)}(A, T, B)
end

function BipartiteProbabilisticNetwork{IT<:AbstractFloat,NT<:AllowedSpeciesTypes}(A::Array{IT,2}, T::Array{NT,1}, B::Array{NT,1})
  check_bipartiteness(A, T, B)
  check_probability_values(A)
  BipartiteProbabilisticNetwork{eltype(A),eltype(T)}(A, T, B)
end
