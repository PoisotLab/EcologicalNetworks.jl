
"""
    NestedHierarchyModel{T<:Integer,FT<:AbstractFloat} <: NetworkGenerator

    `NetworkGenerator` for the nested-hierarchy model


    #### References

    Cattin, M.-F., Bersier, L.-F., Banašek-Richter, C., Baltensperger, R., Gabriel,
    J.-P., 2004. Phylogenetic constraints and adaptation explain food-web structure.
    Nature 427, 835–839. https://doi.org/10.1038/nature02327
"""
mutable struct NestedHierarchyModel{IT<:Integer} <: NetworkGenerator
    size::Tuple{IT,IT}
    links::IT
end

"""
    _generate!(gen::NestedHierarchyModel, ::Type{T}) where {T<:UnipartiteNetwork}

    Primary dispatch for generating networks from the `NestedHierarchyModel`.
"""
function _generate!(gen::NestedHierarchyModel, ::Type{T}) where {T<:UnipartiteNetwork}
    S, L = gen.size[1], gen.links

    S <= 0 && throw(ArgumentError("Number of species must be positive"))
    L <= 0 && throw(ArgumentError("Number of links must be positive"))

    return _nestedhierarchymodel(gen)
end


"""
    NestedHierarchyModel(S::T, X::NT) where {T<:Integer,NT<:Number}

    Constructor for `NestedHierarchyModel` for a unipartite network where the size 
    was passed as in integer `S`.
"""
NestedHierarchyModel(S::T, X::NT) where {T<:Integer,NT<:Number} =
    NestedHierarchyModel((S,S), X)

"""
    NestedHierarchyModel(sz::T, L::ET) where {T<:Tuple{Integer,Integer},ET<:Integer}

    Constructor for `NestedHierarchyModel` for a size tuple `sz` and integer number of links `L`.
"""
NestedHierarchyModel(sz::T, L::ET) where {T<:Tuple{Integer,Integer},ET<:Integer} =
    NestedHierarchyModel{ET}(sz, L)

"""
    NestedHierarchyModel(sz::T, C::CT) where {T<:Tuple{Integer,Integer},CT<:AbstractFloat}

    Constructor for `NestedHierarchyModel` for a size tuple `sz` and a float connectance `C`.
"""
NestedHierarchyModel(sz::T, C::CT) where {T<:Tuple{Integer,Integer},CT<:AbstractFloat} =
    NestedHierarchyModel(sz, C * sz[1] * sz[2])

"""
    NestedHierarchyModel(net::ENT) where {ENT<:UnipartiteNetwork} 

    Constructor for `NestedHierarchyModel` creates a generated based on the same richness 
    and links as an existing network `net`
"""
NestedHierarchyModel(net::ENT) where {ENT<:UnipartiteNetwork} =
    NestedHierarchyModel(richness(net), links(net))



"""
    _nestedhierarchymodel(S::Int64, L::Int64)

    Implementation of generating networks for `NestedHierarchyModel`
"""
function _nestedhierarchymodel(gen)

    S, L = gen.size[1], gen.links
    # Evaluate input
    L >= S * S &&
        throw(ArgumentError("Number of links L cannot be larger than the richness squared"))
    L <= 0 && throw(ArgumentError("Number of links L must be positive"))

    # Initiate matrix
    A = UnipartiteNetwork(zeros(Bool, (S, S)))

    Co = (L / (S * S))

    # Assign values to all species and sort in an ascending order
    e = sort(rand(S))

    # Beta parameter (after Allesina et al. 2008)
    # Classic niche: β = 1.0/(2.0*C)-1.0
    β = (S - 1.0) / (2.0 * Co * S) - 1.0

    # Evaluate input
    β == 0 &&
        throw(ArgumentError("β value is equal to zero! Try decreasing number of links"))

    # Random variable from the Beta distribution
    X = rand(Beta(1.0, β), 1)

    # 'r' values are assigned to all species
    r = e .* X

    # Number of prey for predator i, li rounded to the nearest integer
    expectedlinks = ((r ./ sum(r)) .* L)
    observedlinks = map(x -> round(Int, x), expectedlinks)

    totallinks = sum(observedlinks)

    # User message: number of links to be assigned
    # println("Nested hierarchy model with ", totallinks, " links to assign")

    # Links which may happen to exceed S are set to S-1
    for link = 1:S

        if observedlinks[link] >= S

            observedlinks[link] = S - 1

        end

    end

    # Ensure that the first species has no links
    observedlinks[1] = 0

    # Species pool
    species_pool = species(A)

    # Create dictionaries with all the species indices and names

    # Strings into indices
    sp_pos = Dict{String,Int64}()

    for (n, f) in enumerate(species_pool)

        sp_pos[f] = n

    end

    # Indices into strings
    sp_str = Dict{Int64,String}()

    for (n, f) in enumerate(species_pool)

        sp_str[n] = f

    end

    # Species already predated
    predated = []

    # Assign links to all consumers except for the first one (basal)
    for consumer = 2:S

        # STAGE 1: Assign species with smaller niche value

        # Assign species randomly unless one has other predators
        eligible = StatsBase.sample(1:(consumer-1), (consumer - 1), replace = false)

        linkstoassign = observedlinks[consumer]

        # Hold the last resource assagned in at this stage
        last_resource = 0

        # Loop through a random resources
        for resource in eligible

            # Update last resource holder
            last_resource = resource

            # Break the loop in case of reaching desired number of links
            linkstoassign == 0 && break

            # Assign link
            A[consumer, resource] = true
            linkstoassign = linkstoassign - 1

            # Update the predatored species array
            push!(predated, sp_str[resource])

            # If there are other predators break this
            (sum(A[:, resource]) > 1) && break

        end

        # Go to another consumer in case there are no more links
        linkstoassign == 0 && continue

        # STAGE 2: if the previos resource had a consumer assign resource from th eunion

        # Make a union of all consumers feeding on last_resource
        shared_consumers = A[:, species_pool[last_resource]]
        resource_union = Set{String}()
        [union!(resource_union, A[cons, :]) for cons in shared_consumers]

        # Remove species already utilized by current consumer
        resource_union = setdiff(resource_union, A[species_pool[consumer], :])

        # Shuffle the resource_union
        resource_union = StatsBase.sample(
            collect(resource_union),
            length(resource_union),
            replace = false,
        )

        for resource in resource_union

            linkstoassign == 0 && break

            A[consumer, sp_pos[resource]] = true
            linkstoassign = linkstoassign - 1

            # Update the no_predator array
            push!(predated, resource)

        end

        # Go to another consumer in case there are no more links
        linkstoassign == 0 && continue

        # STAGE 3: randomly assign resources without predators

        # Remove already utilized species
        not_predated = setdiff(species_pool, predated)

        # Shuffle the current set
        not_predated =
            StatsBase.sample(collect(not_predated), length(not_predated), replace = false)

        # Assign links
        for resource in not_predated

            linkstoassign == 0 && break

            A[consumer, sp_pos[resource]] = true
            linkstoassign = linkstoassign - 1

        end

        # Go to another consumer in case there are no more links
        linkstoassign == 0 && continue

        # STAGE 4: Randomly assign species from the rest of the resources

        # Rest of the unassigned species!
        diet = collect(A[species(A)[consumer], :])

        # Get rid of specis already assigned to the current consumer
        not_consumed = setdiff(species_pool, diet)

        # Shuffle the set
        not_consumed =
            StatsBase.sample(collect(not_consumed), length(not_consumed), replace = false)

        # Assign links
        for resource in not_consumed

            linkstoassign == 0 && break

            A[consumer, sp_pos[resource]] = true
            linkstoassign = linkstoassign - 1

        end

    end

    return (A)

end
