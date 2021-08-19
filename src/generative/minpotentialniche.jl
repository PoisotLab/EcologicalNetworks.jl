"""
    MinimumPotentialNiche


    Generator a `UnipartiteNetwork` with links assigned according to minimum
    potential niche model for given number of `S`, links `L`, and
    probability of `forbidden` link occurence.

    #### References

    Allesina, S., Alonso, D., Pascual, M., 2008. A General Model for Food Web
    Structure. Science 320, 658–661. https://doi.org/10.1126/science.1156269
"""
mutable struct MinimumPotentialNiche{T<:Integer,FT<:AbstractFloat} <: NetworkGenerator
    size::Tuple{T,T}
    connectance::FT
    forbiddenlinkprob::FT
end

"""
    _generate(gen::MinimumPotentialNiche, ::Type{T}) where {T <: UnipartiteNetwork}

    Primary dispatch for mpn generation
"""
function _generate(gen::MinimumPotentialNiche, ::Type{T}) where {T<:UnipartiteNetwork}
    C = gen.connectance
    C >= 0.5 && throw(ArgumentError("The connectance cannot be larger than 0.5"))
    C <= 0 && throw(ArgumentError("The connectance must be above than 0"))

    return _mpnmodel(gen)
end

"""
    MinimumPotentialNiche


    Constructor for `MinimumPotentialNiche` generator
    for given number tuple of sizes `sz`, connectance `C` and
    probability of `forbidden` link occurence.
"""
MinimumPotentialNiche(
    sz::ST,
    C::CT,
    forbidden::RT,
) where {ST<:Tuple{Integer,Integer},CT<:Number,RT<:Number} = begin

    return MinimumPotentialNiche{typeof(sz[1]),CT}(sz, C, CT(forbidden))
end

"""
    MinimumPotentialNiche


    Constructor for `MinimumPotentialNiche` generator
    for given number of `S`, links `L` and
    probability of `forbidden` link occurence.
"""
MinimumPotentialNiche(
    S::T,
    L::LT,
    forbidden::NT,
) where {T<:Integer,LT<:Integer,NT<:Number} =
    MinimumPotentialNiche((S, S), L / (S * S), forbidden)

"""
    MinimumPotentialNiche


    Constructor for `MinimumPotentialNiche` generator
    for unipartite networks with `S` species, `L` links and
    probability of `forbidden` link occurence.
"""
MinimumPotentialNiche(
    S::T,
    C::FT,
    forbidden::NT,
) where {T<:Integer,FT<:AbstractFloat,NT<:Number} = begin
    MinimumPotentialNiche((S, S), C, forbidden)
end


"""
    MinimumPotentialNiche(N::T) where {T<: UnipartiteNetwork}

    Constructor for `MinimumPotentialNiche` generator
    from a real network. 
    
    still needs to estimate forbidden link prob. there are papers to do this but not off the top of my head
"""
function MinimumPotentialNiche(N::T) where {T<:UnipartiteNetwork}
    # TODO: Estimate proportion of forbidden links
    forbidden = 0
    return MinimumPotentialNiche((richness(N), richness(N)), connectance(N), forbidden)
end


"""
    _mpnmodel(gen)

    Implements generation of the `MinimumPotentialNiche`.
"""
function _mpnmodel(gen)
    S = size(gen)[1]
    Co = gen.connectance
    forbidden = gen.forbiddenlinkprob


    # Beta distribution parameter
    β = 1.0 / (2.0 * Co) - 1.0

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
        n[small_species_index] = 0.0
        r[small_species_index] = 0.0
    end

    # Testing
    # -------------------------------------------------------------------------
    # ranges = Dict{Int64, Tuple}()
    # -------------------------------------------------------------------------

    for consumer = 1:S

        # For testing
        # ---------------------------------------------------------------------
        # u = c[consumer] + r[consumer]
        # l = c[consumer] - r[consumer]
        # diet = findall(x -> (x > l) & (x < u), n)
        # #println("Species ", diet, " fall into diet of consumer ", consumer)
        # length(diet) != 0 && (ranges[consumer] = (diet[1], diet[end]))
        # ---------------------------------------------------------------------

        for resource = 2:(S-1)

            lower = (n[resource] > (c[consumer] - r[consumer]))
            lowerminus = (n[resource-1] > (c[consumer] - r[consumer]))
            upper = n[resource] < (c[consumer] + r[consumer])
            upperplus = n[resource+1] < (c[consumer] + r[consumer])

            if (upper & lower)

                (rand() < (1 - forbidden)) && (A[consumer, resource] = true)

                # Take care of first and last resource if they belong to the range
                ((resource - 1 == 1) & lowerminus) && (A[consumer, resource-1] = true)
                ((resource + 1 == S) & upperplus) && (A[consumer, resource+1] = true)

                # Edges of range
                lowerminus || (A[consumer, resource] = true)
                upperplus || (A[consumer, resource] = true)


            end

        end

    end

    return A

end
