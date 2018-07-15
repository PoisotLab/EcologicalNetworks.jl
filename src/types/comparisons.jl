import Base: <, ≤

function <(n::NT, n::NT) where {T <: QuantitativeNetwork, NT <: Number}
   ReturnType = T <: AbstractBipartiteNetwork ? BipartiteNetwork : UnipartiteNetwork
   return ReturnType(N.A .< n, species_objects(N)...)
end

function <(n::NT, n::NT) where {T <: ProbabilisticNetwork, NT <: AbstractFloat}
   ReturnType = T <: AbstractBipartiteNetwork ? BipartiteNetwork : UnipartiteNetwork
   return ReturnType(N.A .< n, species_objects(N)...)
end

function <(n::NT, n::NT) where {T <: QuantitativeNetwork, NT <: Number}
   ReturnType = T <: AbstractBipartiteNetwork ? BipartiteNetwork : UnipartiteNetwork
   return ReturnType(n .< N.A, species_objects(N)...)
end

function <(n::NT, n::NT) where {T <: ProbabilisticNetwork, NT <: AbstractFloat}
   ReturnType = T <: AbstractBipartiteNetwork ? BipartiteNetwork : UnipartiteNetwork
   return ReturnType(n .< N.A, species_objects(N)...)
end


function ≤(n::NT, n::NT) where {T <: QuantitativeNetwork, NT <: Number}
   ReturnType = T <: AbstractBipartiteNetwork ? BipartiteNetwork : UnipartiteNetwork
   return ReturnType(N.A .≤ n, species_objects(N)...)
end

function ≤(n::NT, n::NT) where {T <: ProbabilisticNetwork, NT <: AbstractFloat}
   ReturnType = T <: AbstractBipartiteNetwork ? BipartiteNetwork : UnipartiteNetwork
   return ReturnType(N.A .≤ n, species_objects(N)...)
end

function ≤(n::NT, n::NT) where {T <: QuantitativeNetwork, NT <: Number}
   ReturnType = T <: AbstractBipartiteNetwork ? BipartiteNetwork : UnipartiteNetwork
   return ReturnType(n .≤ N.A, species_objects(N)...)
end

function ≤(n::NT, n::NT) where {T <: ProbabilisticNetwork, NT <: AbstractFloat}
   ReturnType = T <: AbstractBipartiteNetwork ? BipartiteNetwork : UnipartiteNetwork
   return ReturnType(n .≤ N.A, species_objects(N)...)
end
