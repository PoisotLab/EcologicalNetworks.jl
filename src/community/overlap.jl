"""
    overlap(N::T; dims=dims::Union{Nothing,Integer}=nothing) where {T <: BipartiteNetwork}

Returns the overlap graph for a bipartite network. The `dims` keyword argument
can be `1` (default; overlap between top-level species) or `2` (overlap between
bottom-level species). See the documentation for `?overlap` for the output
format.
"""
function overlap(N::T; dims::Integer=1) where {T <: BipartiteNetwork}
    return overlap(convert(UnipartiteNetwork, N); dims=dims)
end

"""
    overlap(N::T; dims::Union{Nothing,Integer}=nothing) where {T <: UnipartiteNetwork}

Returns the overlap graph for a unipartite network. The `dims` keyword argument
can be `1` (overlap based on preys) or `2` (overlap based on predators), or
`nothing` (default; overlap based on both predators and preys). The overlap is
returned as a vector of named tuples, with elements `pair` (a tuple of species
names), and `overlap` (the number of shared interactors). The ordering within
the pair of species is unimportant, since overlap graphs are symetrical.
"""
function overlap(N::T; dims::Union{Nothing,Integer}=nothing) where {T <: UnipartiteNetwork}

    if dims !== nothing
        dims== 1 || dims == 2 || throw(ArgumentError("dims can only be nothing, 1, or 2 -- you used $(dims)"))
    end

    itype = Pair{Set{last(eltype(N))},Int64}
    overlaps = Vector{itype}()

    for i in 1:(richness(N; dims=dims)-1)
        s1 = species(N; dims=dims)[i]
        s1suc = N[s1,:]
        s1pre = N[:,s1]
        isnothing(dims) && (s1set = union(s1suc, s1pre))
        dims == 1 && (s1set = s1suc)
        dims == 2 && (s1set = s1pre)
        for j in (i+1):(richness(N; dims=dims))
            s2 = species(N; dims=dims)[j]
            s2suc = N[s2,:]
            s2pre = N[:,s2]
            isnothing(dims) && (s2set = union(s2suc, s2pre))
            dims == 1 && (s2set = s2suc)
            dims == 2 && (s2set = s2pre)
            this_overlap = length(intersect(s1set, s2set))
            if this_overlap > 0
                push!(overlaps, Pair(Set((s1, s2)), this_overlap))
            end
        end
    end

    return overlaps
end

function AJS(N::T; dims::Integer=1) where {T <: BipartiteNetwork}
    return AJS(convert(UnipartiteNetwork, N); dims=dims)
end

"""
    AJS(N::T; dims::Union{Nothing,Integer}=nothing) where {T <: UnipartiteNetwork}

Additive Jaccard Similarity for pairs of species in the network. AJS
varies between 0 (no common species) to 1 (same profiles). This function can be
used to measure AJS based on only successors or predecessors, using the `dims`
argument.

Note that this function uses all *direct* preys and predators to measure the
similarity (and so does not go beyond the immediate neighbors).

#### References

Gao, P., Kupfer, J.A., 2015. Uncovering food web structure using a novel trophic
similarity measure. Ecological Informatics 30, 110–118.
https://doi.org/10.1016/j.ecoinf.2015.09.013
"""
function AJS(N::T; dims::Union{Nothing,Integer}=nothing) where {T <: UnipartiteNetwork}

    if dims !== nothing
        dims == 1 || dims == 2 || throw(ArgumentError("dims can only be nothing, 1, or 2 -- you used $(dims)"))
    end

    itype = Pair{Set{last(eltype(N))},Float64}
    overlaps = Vector{itype}()

    for i in 1:(richness(N; dims=dims)-1)
        s1 = species(N; dims=dims)[i]
        s1suc = N[s1,:]
        s1pre = N[:,s1]
        isnothing(dims) && (s1set = union(s1suc, s1pre))
        dims == 1 && (s1set = s1suc)
        dims == 2 && (s1set = s1pre)
        for j in (i+1):(richness(N; dims=dims))
            s2 = species(N; dims=dims)[j]
            s2suc = N[s2,:]
            s2pre = N[:,s2]
            isnothing(dims) && (s2set = union(s2suc, s2pre))
            dims == 1 && (s2set = s2suc)
            dims == 2 && (s2set = s2pre)
            a = length(intersect(s1set, s2set))
            b = length(setdiff(s1set, s2set))
            c = length(setdiff(s2set, s1set))
            this_overlap = a/(a+b+c)
            if this_overlap > 0.0
                push!(overlaps, Pair(Set((s1, s2)), this_overlap))
            end
        end
    end

    return overlaps

end

function EAJS(N::T; dims::Integer=1) where {T <: BipartiteNetwork}
    return EAJS(convert(UnipartiteNetwork, N); dims=dims)
end

"""
    EAJS(N::T; dims::Union{Nothing,Integer}=nothing) where {T <: UnipartiteNetwork}

Extended Additive Jaccard Similarity for pairs of species in the network. AJS
varies between 0 (no common species) to 1 (same profiles). This function can be
used to measure AJS based on only successors or predecessors, using the `dims`
argument.

Note that this function counts all interactions up to a distance of 50 to define
the neighbourhood of a species. This should be more than sufficient for most
ecological networks.

#### References

Gao, P., Kupfer, J.A., 2015. Uncovering food web structure using a novel trophic
similarity measure. Ecological Informatics 30, 110–118.
https://doi.org/10.1016/j.ecoinf.2015.09.013
"""
function EAJS(N::T; dims::Union{Nothing,Integer}=nothing) where {T <: UnipartiteNetwork}

    sp = shortest_path(N)
    Y = UnipartiteNetwork(sp.>0, species_objects(N)...)

    if dims !== nothing
        dims == 1 || dims == 2 || throw(ArgumentError("dims can only be nothing, 1, or 2 -- you used $(dims)"))
    end

    itype = Pair{Set{last(eltype(N))},Float64}
    overlaps = Vector{itype}()

    for i in 1:(richness(Y; dims=dims)-1)
        s1 = species(Y; dims=dims)[i]
        s1suc = Y[s1,:]
        s1pre = Y[:,s1]
        isnothing(dims) && (s1set = union(s1suc, s1pre))
        dims == 1 && (s1set = s1suc)
        dims == 2 && (s1set = s1pre)
        for j in (i+1):(richness(Y; dims=dims))
            s2 = species(Y; dims=dims)[j]
            s2suc = Y[s2,:]
            s2pre = Y[:,s2]
            isnothing(dims) && (s2set = union(s2suc, s2pre))
            dims == 1 && (s2set = s2suc)
            dims == 2 && (s2set = s2pre)
            a = length(intersect(s1set, s2set))
            b = length(setdiff(s1set, s2set))
            c = length(setdiff(s2set, s1set))
            this_overlap = a/(a+b+c)
            if this_overlap > 0.0
                push!(overlaps, Pair(Set((s1, s2)), this_overlap))
            end
        end
    end

    return overlaps

end
