
"""
    NicheModel
"""
mutable struct NicheModel{T<:Integer, FT<:AbstractFloat} <: NetworkGenerator 
    size::Tuple{T,T}
    connectance::FT
end 
NicheModel(; size::T=30, connectance::FT=0.3) where {T <: Union{Tuple{Integer}, Integer}, FT <: AbstractFloat} = NicheModel(size, connectance)
NicheModel(sz::T, X::NT) where {T <: Integer, NT<:Number} = NicheModel((sz,sz), X)
NicheModel(sz::T, E::ET) where {T <: Tuple{Integer,Integer}, ET<:Integer} = begin
    
    E >= sz[1]*sz[1] && throw(ArgumentError("Number of links L cannot be larger than the richness squared"))
    E <= 0 && throw(ArgumentError("Number of links L must be positive"))

    NicheModel(sz,E/(sz[1]*sz[2]))
end 
NicheModel(sz::T, C::CT) where {T <: Tuple{Integer,Integer}, CT<:AbstractFloat} = NicheModel(sz, C)


NicheModel(net::ENT) where {ENT <: UnipartiteNetwork} = NicheModel(richness(net), links(net))


_generate!(gen::NicheModel, target::T) where {T <: UnipartiteNetwork} = nichemodel(size(gen)[1], gen.connectance)



"""
    nichemodel(S::Int64, L::Int64)

Return `UnipartiteNetwork` where resources are assign to consumers according to
niche model for a network of `S` species and `L` links.

#### References

Williams, R., Martinez, N., 2000. Simple rules yield complex food webs. Nature
404, 180–183.
"""
function nichemodel(S::Int64, L::Int64)

    L >= S*S && throw(ArgumentError("Number of links L cannot be larger than the richness squared"))
    L <= 0 && throw(ArgumentError("Number of links L must be positive"))

    C = L/(S*S)

    return nichemodel(S, C)

end


"""
    nichemodel(N::T) where {T <: UnipartiteNetwork}

Applied to empirical `UnipartiteNetwork` return its randomized version.

#### References

Williams, R., Martinez, N., 2000. Simple rules yield complex food webs. Nature
404, 180–183.
"""
function nichemodel(N::T) where {T <: UnipartiteNetwork}
    return nichemodel(richness(N), connectance(N))
end

"""
    nichemodel(S::Int64, C::Float64)

#### References

Williams, R., Martinez, N., 2000. Simple rules yield complex food webs. Nature
404, 180–183.
"""
function nichemodel(S::Int64, C::Float64)

    C >= 0.5 && throw(ArgumentError("The connectance cannot be larger than 0.5"))

    # Beta distribution parameter
    β = 1.0/(2.0*C)-1.0

    # Pre-allocate the network
    A = UnipartiteNetwork(zeros(Bool, (S, S)))

    # Generate body size
    n = sort(rand(Uniform(0.0, 1.0), S))

    # Pre-allocate centroids
    c = zeros(Float64, S)

    # Generate random ranges
    r = n .* rand(Beta(1.0, β), S)

    # Generate random centroids
    for s in 1:S
        c[s] = rand(Uniform(r[s]/2, n[s]))
    end

    # The smallest species has a body size and range of 0
    for small_species_index in findall(x -> x == minimum(n), n)
        r[small_species_index] = 0.0
    end

    for consumer in 1:S
        for resource in 1:S
            if n[resource] < c[consumer] + (r[consumer]/2)
                if n[resource] > c[consumer] - (r[consumer]/2)
                    A[consumer, resource] = true
                end
            end
        end
    end

    # Check for disconnected species?

    return A

end

"""

    nichemodel(parameters::Tuple)

Parameters tuple can also be provided in the form (Species::Int64, Co::Float64)
or (Species::Int64, Int::Int64).

#### References

Williams, R., Martinez, N., 2000. Simple rules yield complex food webs. Nature
404, 180–183.
"""
function nichemodel(parameters::Tuple)
    return nichemodel(parameters[1], parameters[2])
end
