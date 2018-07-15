import Base: <, ≤

function ≤(N::NT, n::T) where {T <: AbstractFloat, NT <: BipartiteProbabilisticNetwork{T,S}}
  @assert 0.0 ≤= n ≤= 1.0
  return BipartiteNetwork(N.A .≤ n, species_objects(N)...)
end


function ≤(n::T, N::NT) where {T <: AbstractFloat, NT <: BipartiteProbabilisticNetwork{T,S}}
  @assert 0.0 ≤= n ≤= 1.0
  return BipartiteNetwork(n .≤ N.A, species_objects(N)...)
end


function ≤(N::NT, n::T) where {T <: AbstractFloat, NT <: UnipartiteProbabilisticNetwork{T,S}}
  @assert 0.0 ≤= n ≤= 1.0
  return UnipartiteNetwork(N.A .≤ n, species_objects(N)...)
end


function ≤(n::T, N::NT) where {T <: AbstractFloat, NT <: UnipartiteProbabilisticNetwork{T,S}}
  @assert 0.0 ≤= n ≤= 1.0
  return UnipartiteNetwork(n .≤ N.A, species_objects(N)...)
end


function ≤(N::NT, n::T) where {T <: Number, NT <: BipartiteQuantitativeNetwork{T,S}}
  return BipartiteNetwork(N.A .≤ n, species_objects(N)...)
end


function ≤(n::T, N::NT) where {T <: Number, NT <: BipartiteQuantitativeNetwork{T,S}}
  return BipartiteNetwork(n .≤ N.A, species_objects(N)...)
end


function ≤(N::NT, n::T) where {T <: Number, NT <: UnipartiteQuantitativeNetwork{T,S}}
  return UnipartiteNetwork(N.A .≤ n, species_objects(N)...)
end


function ≤(n::T, N::NT) where {T <: Number, NT <: UnipartiteQuantitativeNetwork{T,S}}
  return UnipartiteNetwork(n .≤ N.A, species_objects(N)...)
end

function <(N::NT, n::T) where {T <: AbstractFloat, NT<:BipartiteProbabilisticNetwork{T,S}}
  @assert 0.0 <= n <= 1.0
  return BipartiteNetwork(N.A .< n, species_objects(N)...)
end


function <(n::T, N::NT) where {T <: AbstractFloat, NT<:BipartiteProbabilisticNetwork{T,S}}
  @assert 0.0 <= n <= 1.0
  return BipartiteNetwork(n .< N.A, species_objects(N)...)
end


function <(N::NT, n::T) where {T <: AbstractFloat, NT<:UnipartiteProbabilisticNetwork{T,S}}
  @assert 0.0 <= n <= 1.0
  return UnipartiteNetwork(N.A .< n, species_objects(N)...)
end


function <(n::T, N::NT) where {T <: AbstractFloat, NT<:UnipartiteProbabilisticNetwork{T,S}}
  @assert 0.0 <= n <= 1.0
  return UnipartiteNetwork(n .< N.A, species_objects(N)...)
end


function <(N::NT, n::T) where {T <: Number, NT<:BipartiteQuantitativeNetwork{T,S}}
  return BipartiteNetwork(N.A .< n, species_objects(N)...)
end


function <(n::T, N::NT) where {T <: Number, NT<:BipartiteQuantitativeNetwork{T,S}}
  return BipartiteNetwork(n .< N.A, species_objects(N)...)
end


function <(N::NT, n::T) where {T <: Number, NT<:UnipartiteQuantitativeNetwork{T,S}}
  return UnipartiteNetwork(N.A .< n, species_objects(N)...)
end


function <(n::T, N::NT) where {T <: Number, NT<:UnipartiteQuantitativeNetwork{T,S}}
  return UnipartiteNetwork(n .< N.A, species_objects(N)...)
end
