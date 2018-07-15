import Base: <, ≤

function <(N::T, n::T) where {T <: QuantitativeNetwork, n <: Number}
   ReturnType = T <: AbstractBipartiteNetwork ? BipartiteNetwork : UnipartiteNetwork
   return ReturnType(N.A .< n, species_objects(N)...)
end

function <(N::T, n::T) where {T <: ProbabilisticNetwork, n <: AbstractFloat}
   ReturnType = T <: AbstractBipartiteNetwork ? BipartiteNetwork : UnipartiteNetwork
   return ReturnType(N.A .< n, species_objects(N)...)
end

function <(n::T, N::T) where {T <: QuantitativeNetwork, n <: Number}
   ReturnType = T <: AbstractBipartiteNetwork ? BipartiteNetwork : UnipartiteNetwork
   return ReturnType(n .< N.A, species_objects(N)...)
end

function <(n::T, N::T) where {T <: ProbabilisticNetwork, n <: AbstractFloat}
   ReturnType = T <: AbstractBipartiteNetwork ? BipartiteNetwork : UnipartiteNetwork
   return ReturnType(n .< N.A, species_objects(N)...)
end


function ≤(N::T, n::T) where {T <: QuantitativeNetwork, n <: Number}
   ReturnType = T <: AbstractBipartiteNetwork ? BipartiteNetwork : UnipartiteNetwork
   return ReturnType(N.A .≤ n, species_objects(N)...)
end

function ≤(N::T, n::T) where {T <: ProbabilisticNetwork, n <: AbstractFloat}
   ReturnType = T <: AbstractBipartiteNetwork ? BipartiteNetwork : UnipartiteNetwork
   return ReturnType(N.A .≤ n, species_objects(N)...)
end

function ≤(n::T, N::T) where {T <: QuantitativeNetwork, n <: Number}
   ReturnType = T <: AbstractBipartiteNetwork ? BipartiteNetwork : UnipartiteNetwork
   return ReturnType(n .≤ N.A, species_objects(N)...)
end

function ≤(n::T, N::T) where {T <: ProbabilisticNetwork, n <: AbstractFloat}
   ReturnType = T <: AbstractBipartiteNetwork ? BipartiteNetwork : UnipartiteNetwork
   return ReturnType(n .≤ N.A, species_objects(N)...)
end
