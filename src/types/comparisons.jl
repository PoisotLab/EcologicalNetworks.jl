import Base: <, ≤

function <(N::T, n::NT) where {T <: QuantitativeNetwork, NT <: Number}
   ReturnType = T <: AbstractBipartiteNetwork ? BipartiteNetwork : UnipartiteNetwork
   return ReturnType(N.edges .< n, species_objects(N)...)
end

function <(N::T, n::NT) where {T <: ProbabilisticNetwork, NT <: AbstractFloat}
   ReturnType = T <: AbstractBipartiteNetwork ? BipartiteNetwork : UnipartiteNetwork
   return ReturnType(N.edges .< n, species_objects(N)...)
end

function <(n::NT, N::T) where {T <: QuantitativeNetwork, NT <: Number}
   ReturnType = T <: AbstractBipartiteNetwork ? BipartiteNetwork : UnipartiteNetwork
   return ReturnType(n .< N.edges, species_objects(N)...)
end

function <(n::NT, N::T) where {T <: ProbabilisticNetwork, NT <: AbstractFloat}
   ReturnType = T <: AbstractBipartiteNetwork ? BipartiteNetwork : UnipartiteNetwork
   return ReturnType(n .< N.edges, species_objects(N)...)
end


function ≤(N::T, n::NT) where {T <: QuantitativeNetwork, NT <: Number}
   ReturnType = T <: AbstractBipartiteNetwork ? BipartiteNetwork : UnipartiteNetwork
   return ReturnType(N.edges .≤ n, species_objects(N)...)
end

function ≤(N::T, n::NT) where {T <: ProbabilisticNetwork, NT <: AbstractFloat}
   ReturnType = T <: AbstractBipartiteNetwork ? BipartiteNetwork : UnipartiteNetwork
   return ReturnType(N.edges .≤ n, species_objects(N)...)
end

function ≤(n::NT, N::T) where {T <: QuantitativeNetwork, NT <: Number}
   ReturnType = T <: AbstractBipartiteNetwork ? BipartiteNetwork : UnipartiteNetwork
   return ReturnType(n .≤ N.edges, species_objects(N)...)
end

function ≤(n::NT, N::T) where {T <: ProbabilisticNetwork, NT <: AbstractFloat}
   ReturnType = T <: AbstractBipartiteNetwork ? BipartiteNetwork : UnipartiteNetwork
   return ReturnType(n .≤ N.edges, species_objects(N)...)
end
