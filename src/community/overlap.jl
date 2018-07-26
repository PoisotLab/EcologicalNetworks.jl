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

    overlaps = Vector{NamedTuple}()

    for i in 1:(richness(N; dims=dims)-1)
        s1 = species(N; dims=dims)[i]
        s1suc = N[s1,:]
        s1pre = N[:,s1]
        dims === nothing && (s1set = union(s1suc, s1pre))
        dims == 1 && (s1set = s1suc)
        dims == 2 && (s1set = s1pre)
        for j in (i+1):(richness(N; dims=dims))
            s2 = species(N; dims=dims)[j]
            s2suc = N[s2,:]
            s2pre = N[:,s2]
            dims === nothing && (s2set = union(s2suc, s2pre))
            dims == 1 && (s2set = s2suc)
            dims == 2 && (s2set = s2pre)
            this_overlap = length(intersect(s1set, s2set))
            if this_overlap > 0
                push!(overlaps, (pair = (s1, s2), overlap = this_overlap))
            end
        end
    end
    
    return overlaps
end
