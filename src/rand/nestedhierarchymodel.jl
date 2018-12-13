"""

    nestedhierarchymodel(S::Int64, L::Int64)

Return `UnipartiteNetwork` where resources are assigned to consumers according
to the nested hierarchy model for `S` species and `L`.

> Cattin, M.-F. et al. (2004) ‘Phylogenetic constraints and adaptation explain
> food-web structure’, Nature, 427(6977), pp. 835–839. doi: 10.1038/nature02327.

# Examples
```jldoctest
julia> A = nestedhierarchymodel(25, 700)
```

See also: `nichemodel`, `cascademodel`, `mpnmodel`

"""
function nestedhierarchymodel(S::Int64, L::Int64)

    # Evaluate input
    L >= S*S && throw(ArgumentError("Number of links L cannot be larger than the richness squared"))
    L <= 0 && throw(ArgumentError("Number of links L must be positive"))

    # Initiate matrix
    A = UnipartiteNetwork(zeros(Bool, (S, S)))

    Co = (L/(S*S))

    # Assign values to all species and sort in an ascending order
    e = sort(rand(S))

    # Beta parameter (after Allesina et al. 2008)
    # Classic niche: β = 1.0/(2.0*C)-1.0
    b = (S - 1.0)/(2.0*Co*S) - 1.0

    # Evaluate input
    b == 0 && throw(ArgumentError("β value is equal to zero! Try decreasing number of links"))

    # Random variable from the Beta distribution
    X = rand(Beta(1.0, b), 1)

    # 'r' values are assigned to all species
    r = e .* X

    # Number of prey for predator i, li rounded to the nearest integer
    expectedlinks = ((r ./ sum(r)) .* L)
    observedlinks = map(x -> round(Int, x), expectedlinks)

    totallinks = sum(observedlinks)

    # User message: number of links to be assigned
    # println("Nested hierarchy model with ", totallinks, " links to assign")

    # Links which may happen to exceed S are set to S-1
    for link in 1:S

        if observedlinks[link] >= S

            observedlinks[link] = S-1

        end

    end

    # Ensure that the first species has no links
    observedlinks[1] = 0

    # Species pool
    species_pool = species(A)

    # Create dictionaries with all the species indices and names

    # Strings into indices
    sp_pos = Dict{String, Int64}()

    for (n, f) in enumerate(species_pool)

        sp_pos[f] = n

    end

    # Indices into strings
    sp_str = Dict{Int64, String}()

    for (n, f) in enumerate(species_pool)

        sp_str[n] = f

    end

    # Species already predated
    predated = []

    # Assign links to all consumers except for the first one (basal)
    for consumer in 2:S

        # STAGE 1: Assign species with smaller niche value

        # Assign species randomly unless one has other predators
        eligible = sample(1:(consumer-1), (consumer-1), replace = false)

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
            (sum(A[:,resource]) > 1) && break

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
        resource_union = sample(collect(resource_union), length(resource_union), replace = false)

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
        not_predated = sample(collect(not_predated), length(not_predated), replace = false)

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
        not_consumed = sample(collect(not_consumed), length(not_consumed), replace = false)

        # Assign links
        for resource in not_consumed

            linkstoassign == 0 && break

            A[consumer, sp_pos[resource]] = true
            linkstoassign = linkstoassign - 1

        end

    end

    return(A)

end

"""

    nestedhierarchymodel(S::Int64, Co::Float64)

Connectance can be provided instead of number of links.

# Examples
```jldoctest
julia> A = nestedhierarchymodel(25, 0.45)
```

See also: `nichemodel`, `cascademodel`, `mpnmodel`

"""
function nestedhierarchymodel(S::Int64, Co::Float64)

    # Calculate number of links L from connectednes
    L = round(Int, (Co*(S*S)))

    return nestedhierarchymodel(S, L)

end

"""

    nestedhierarchymodel(N::T) {T <: UnipartiteNetwork}

Applied to empirical `UnipartiteNetwork` return its randomized version.

# Examples
```jldoctest
julia> empirical_foodweb = EcologicalNetworks.nz_stream_foodweb()[1]
julia> A = nestedhierarchymodel(empirical_foodweb)
```
"""
function nestedhierarchymodel(N::T) where {T <: UnipartiteNetwork}

    return nestedhierarchymodel(richness(N), connectance(N))

end

"""

    nestedhierarchymodel(parameters::Tuple)

Parameters tuple can also be provided in the form (Species::Int64, Co::Float64)
or (Species::Int64, Int::Int64).

"""

function nestedhierarchymodel(parameters::Tuple)

    return nestedhierarchymodel(parameters[1], parameters[2])

end
