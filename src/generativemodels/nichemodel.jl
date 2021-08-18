
"""
    NicheModel{IT<:Integer,FT<:AbstractFloat} <: NetworkGenerator

    `NetworkGenerator` for the niche model. 

    #### Reference

    Williams, R., Martinez, N., 2000. Simple rules yield complex food webs. Nature
    404, 180–183.
"""
mutable struct NicheModel{IT<:Integer,FT<:AbstractFloat} <: NetworkGenerator
    size::Tuple{IT,IT}
    connectance::FT
end


"""
    _generate(gen::NicheModel, target::T) where {T <: UnipartiteNetwork}

    Primary dispatch for generating niche model. Called from rand(::NicheModel)
"""
function _generate(gen::NicheModel, ::Type{T}) where {T<:UnipartiteNetwork}
    S = size(gen)[1]
    C = gen.connectance

    C >= 0.5 && throw(ArgumentError("The connectance cannot be larger than 0.5"))

    return _nichemodel(gen)
end 


"""
    NicheModel(S::IT, C::FT)

    Constructor for `NicheModel` where resources are assign to consumers according to
    niche model for a network of `S` species and `L` links.
"""
NicheModel(S::IT, C::FT) where {IT<:Integer,FT<:AbstractFloat} = begin
    C >= 0.5 && throw(ArgumentError("The connectance cannot be larger than 0.5"))
    return NicheModel{IT,FT}((S, S), C)
end


"""
    NicheModel(; richness::T=30, connectance::FT=0.3)

    Constructor for `NicheModel` using keyword arguments.
"""
NicheModel(;
    richness::T = 30,
    connectance::FT = 0.3,
) where {T<:Union{Tuple{Integer},Integer},FT<:AbstractFloat} =
    NicheModel(richness, connectance)

"""
    NicheModel(S::Int64, L::Int64)

    Constructor for `NicheModel` where resources are assign to consumers according to
    niche model for a network of `S` species and `L` links.
"""
NicheModel(S::ST, L::LT) where {ST<:Integer,LT<:Integer} = begin
    L >= S * S &&
    throw(ArgumentError("Number of links L cannot be larger than the richness squared"))
    L <= 0 && throw(ArgumentError("Number of links L must be positive"))

    C = L / (S * S)

    return NicheModel(S, C)
end


"""
    NicheModel(net::ENT) where {ENT <: UnipartiteNetwork}

    Constructor for `NicheModel` which takes an empirical `UnipartiteNetwork`
    as input and return its a generator based on the empirical networks
    richness and connectance.
"""
NicheModel(net::ENT) where {ENT<:UnipartiteNetwork} = NicheModel(richness(net), links(net))

"""
    _nichemodel(gen)

    Implementation of generation of the niche model. 
"""
function _nichemodel(gen)
    S = size(gen)[1]
    C = gen.connectance

    # Beta distribution parameter
    β = 1.0 / (2.0 * C) - 1.0

    # Pre-allocate the network
    A = UnipartiteNetwork(zeros(Bool, (S, S)))

    # Generate body size
    n = sort(rand(Uniform(0.0, 1.0), S))

    # Pre-allocate centroids
    c = zeros(Float64, S)

    # Generate random ranges
    r = n .* rand(Beta(1.0, β), S)

    # Generate random centroids
    for s = 1:S
        c[s] = rand(Uniform(r[s] / 2, n[s]))
    end

    # The smallest species has a body size and range of 0
    for small_species_index in findall(x -> x == minimum(n), n)
        r[small_species_index] = 0.0
    end

    for consumer = 1:S
        for resource = 1:S
            if n[resource] < c[consumer] + (r[consumer] / 2)
                if n[resource] > c[consumer] - (r[consumer] / 2)
                    A[consumer, resource] = true
                end
            end
        end
    end

    # Check for disconnected species?

    return A

end
