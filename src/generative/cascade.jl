
"""
    Cascade{T<:Integer,FT<:AbstractFloat} <: NetworkGenerator

    Network generator which creates `UnipartiteNetwork`s randomly assembled according to
    the cascade model for a given nuber of `S` and connectivity `C`.
    
    #### References

    Cohen, J.E., Newman, C.M., 1985. A stochastic theory of community food webs I.
    Models and aggregated data. Proceedings of the Royal Society of London.
    B. Biological Sciences 224, 421–448. https://doi.org/10.1098/rspb.1985.0042
"""
mutable struct Cascade{T<:Integer,FT<:AbstractFloat} <: NetworkGenerator
    size::Tuple{T,T}
    connectance::FT
end

"""
    _generate(gen::Cascade, ::Type{T}) where {T<:UnipartiteNetwork}

    Primary dispatch for generation. Checks arguments and calls the internal
    function `_casecademodel` to generate the network.
"""
function _generate(gen::Cascade, ::Type{T}) where {T<:UnipartiteNetwork}
    S, Co = gen.size[1], gen.connectance

    maxconnectance = ((S^2 - S) / 2) / (S * S)
    Co >= maxconnectance && throw(
        ArgumentError(
            "Connectance for $(S) species cannot be larger than $(maxconnectance) ",
        ),
    )
    Co <= 0 && throw(ArgumentError("Connectance C must be positive"))
    S <= 0 && throw(ArgumentError("Number of species L must be positive"))

    return _cascademodel(gen)
end


"""
    Cascade(sz::T, X::NT) where {T<:Integer,NT<:Number}

    Cascade constructor for a Unipartite Network where the size `S` is an integer
    and the second argument is either connectance or number of links, which is handled
    on the next call.
"""
Cascade(S::T, X::NT) where {T<:Integer,NT<:Number} = Cascade((S, S), X)

"""
    Cascade(sz::T, X::NT) where {T<:Tuple{Integer,Integer},ET<:Integer} 

    Cascade constructor for a tuple of sizes `sz` and a number of links `L`.
"""
Cascade(sz::T, L::ET) where {T<:Tuple{Integer,Integer},ET<:Integer} =
    Cascade(sz, L / (sz[1] * sz[2]))

"""
    Cascade(sz::T, X::NT) where {T<:Tuple{Integer,Integer},ET<:Integer} 

    Cascade constructor for a tuple of sizes `sz` and connectance `C`.
"""
Cascade(sz::T, C::CT) where {T<:Tuple{Integer,Integer},CT<:AbstractFloat} =
    Cascade(sz, C)


"""
    Cascade(net::ENT) where {ENT<:UnipartiteNetwork}

    Cascade constructor which copies the size/connectance of an
    existing network `net`.
"""
Cascade(net::ENT) where {ENT<:UnipartiteNetwork} =
    Cascade(richness(net), links(net))


"""
    _cascademodel(gen)

    Implmentation of generating networks for the `Cascade`
"""
function _cascademodel(gen)

    S, Co = gen.size[1], gen.connectance
    # Initiate matrix
    A = UnipartiteNetwork(zeros(Bool, (S, S)))

    # For each species randomly asscribe rank e
    e = Random.sort(rand(S); rev = false)

    # Probability for linking two species
    p = 2 * Co * S / (S - 1)

    for consumer = 1:S
        # Rank for a consumer
        rank = e[consumer]

        # Get a set of resources smaller than consumer
        potentialresources = findall(x -> x > rank, e)  # indices
        #resourcesranks = η[potentialresources]         # ranks
        #R = length(potentialresources)                 # length

        # Each gets a link with a probability p
        for resource in potentialresources

            # Take the resources and for each of them check a random number
            # if it is smaller than probability of linking two speceis create
            # a link in the A matrix

            # Random number for a potential resource
            rand() < p && (A[consumer, resource] = true)
        end
    end
    return A
end
