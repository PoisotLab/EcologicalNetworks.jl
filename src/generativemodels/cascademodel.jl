
"""
    CascadeModel
"""
mutable struct CascadeModel{T<:Integer, FT<:AbstractFloat} <: NetworkGenerator 
    size::Tuple{T,T}
    connectance::FT
end 
CascadeModel(; size::T=30, connectance::FT=0.3) where {T <: Union{Tuple{Integer}, Integer}, FT <: AbstractFloat} = CascadeModel(size, connectance)
CascadeModel(sz::T, X::NT) where {T <: Integer, NT<:Number} = CascadeModel((sz,sz), X)
CascadeModel(sz::T, E::ET) where {T <: Tuple{Integer,Integer}, ET<:Integer} = CascadeModel(sz, E/(sz[1]*sz[2]))
CascadeModel(sz::T, C::CT) where {T <: Tuple{Integer,Integer}, CT<:AbstractFloat} = CascadeModel(sz, C)

CascadeModel(net::ENT) where {ENT <: UnipartiteNetwork} = CascadeModel(richness(net), links(net))


_generate!(gen::CascadeModel, target::T) where {T <: UnipartiteNetwork}  = cascademodel(size(gen)[1], gen.connectance)


"""
    cascademodel(S::Int64, Co::Float64)

Return matrix of the type `UnipartiteNetwork` randomly assembled according to
the cascade model for a given nuber of `S` and connectivity `Co`.

See also: `nichemodel`, `mpnmodel`, `nestedhierarchymodel`

#### References

Cohen, J.E., Newman, C.M., 1985. A stochastic theory of community food webs I.
Models and aggregated data. Proceedings of the Royal Society of London. Series
B. Biological Sciences 224, 421–448. https://doi.org/10.1098/rspb.1985.0042
"""
function cascademodel(S::Int64, Co::Float64)

    # Evaluate input
    maxconnectance = ((S^2-S)/2)/(S*S)
    Co >= maxconnectance && throw(ArgumentError("Connectance for $(S) species cannot be larger than $(maxconnectance) "))
    Co <= 0 && throw(ArgumentError("Connectance C must be positive"))
    S <= 0 && throw(ArgumentError("Number of species L must be positive"))

    # Initiate matrix
    A = UnipartiteNetwork(zeros(Bool, (S, S)))

    # For each species randomly asscribe rank e
    e = Random.sort(rand(S); rev=false)

    # Probability for linking two species
    p = 2*Co*S/(S - 1)

    for consumer in  1:S

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

"""
    cascademodel(N::T) where {T <: UnipartiteNetwork}

Applied to a `UnipartiteNetwork` return its randomized version.

#### References

Cohen, J.E., Newman, C.M., 1985. A stochastic theory of community food webs I.
Models and aggregated data. Proceedings of the Royal Society of London. Series
B. Biological Sciences 224, 421–448. https://doi.org/10.1098/rspb.1985.0042
"""
function cascademodel(N::T) where {T <: UnipartiteNetwork}

    return cascademodel(richness(N), connectance(N))

end

"""
    cascademodel(S::Int64, L::Int64)

Number of links can be specified instead of connectance.

#### References

Cohen, J.E., Newman, C.M., 1985. A stochastic theory of community food webs I.
Models and aggregated data. Proceedings of the Royal Society of London. Series
B. Biological Sciences 224, 421–448. https://doi.org/10.1098/rspb.1985.0042
"""
function cascademodel(S::Int64, L::Int64)
    Co = (L/(S*S))
    return cascademodel(S, Co)

end

"""

    cascademodel(parameters::Tuple)

Parameters tuple can also be provided in the form (S::Int64, Co::Float64)
or (S::Int64, L::Int64).

#### References

Cohen, J.E., Newman, C.M., 1985. A stochastic theory of community food webs I.
Models and aggregated data. Proceedings of the Royal Society of London. Series
B. Biological Sciences 224, 421–448. https://doi.org/10.1098/rspb.1985.0042
"""
function cascademodel(parameters::Tuple)
    return cascademodel(parameters[1], parameters[2])
end
