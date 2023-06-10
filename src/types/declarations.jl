"""
    Partiteness{T}

The species in a network are stored in a parametric sub-type of `Partiteness`.
By default, this can be `Unipartite` or `Bipartite`. The inner type `T`
indicates what types can be used to represent species. Note that species
*cannot* be represented as integers, and will instead have a name. We recommend
using strings or symbols.
"""
abstract type Partiteness{T} end

"""
    Interactions{T}

The interactions in a network are stored in a parametric sub-type of
`Interactions`. By default, this can be `Binary`, `Quantitative`, and
`Probabilistic`. The inner type `T` indicates what types are used to represent
interactions.
"""
abstract type Interactions{T} end

"""
    SpeciesInteractionNetwork{P<:Partiteness, E<:Interactions}

A `SpeciesInteractionNetwork` type represents a species interaction network.

This type has two fields: `nodes` (a `Partiteness`), and `edges` (an
`Interactions`). Because these two types are parametric, we can learn everything
there is to know about the data structure in a network by looking at the type
alone.

For example, a bipartite quantitative network where species are symbols and
interactions are 32-bits floating point numbers will have the type

~~~
SpeciesInteractionNetwork{Bipartite{Symbol}, Interactions{Float32}}
~~~

This enables very specialized dispatch and indexing thoughout the package.
"""
struct SpeciesInteractionNetwork{P<:Partiteness, E<:Interactions}
    nodes::P
    edges::E
end

"""
    Bipartite{T <: Any} <: Partiteness{T}

A bipartite set of species is represented by two sets of species, called `top`
and `bottom`. Both set of species are represented as `Vector{T}`, with a few
specific constraints:

1. `T` cannot be a `Number` (*i.e.* nodes must have names, or be other objects)
2. All species in `top` must be unique
2. All species in `bottom` must be unique
2. No species can be found in both `bottom` and `top`
"""
struct Bipartite{T <: Any} <: Partiteness{T}
    top::Vector{T}
    bottom::Vector{T}
    function Bipartite(top::Vector{T}, bottom::Vector{T}) where {T <: Any}
        if T <: Number
            throw(ArgumentError("The nodes IDs in a Bipartite set cannot be numbers"))
        end
        if ~allunique(top)
            throw(ArgumentError("The species in the top level of a bipartite network must be unique"))
        end
        if ~allunique(bottom)
            throw(ArgumentError("The species in the bottom level of a bipartite network must be unique"))
        end
        if ~allunique(vcat(bottom, top))
            throw(ArgumentError("The species in a bipartite network cannot appear in both levels"))
        end
        return new{T}(top, bottom)
    end
end

@testitem "We can construct a bipartite species set with symbols" begin
    set = Bipartite([:a, :b, :c], [:A, :B, :C])
    @test richness(set) == 6
end

@testitem "We can construct a bipartite species set with strings" begin
    set = Bipartite(["a", "b", "c"], ["A", "B", "C", "D"])
    @test richness(set) == 7
end

@testitem "We cannot construct a bipartite set with species on both sides" begin
    @test_throws ArgumentError Bipartite([:a, :b, :c], [:A, :a])
end

@testitem "We cannot construct a bipartite set with non-unique species" begin
    @test_throws ArgumentError Bipartite([:a, :b, :b], [:A, :B])
end

@testitem "We cannot construct a bipartite set with integer-valued species" begin
    @test_throws ArgumentError Bipartite([1, 2, 3, 4], [5, 6, 7, 8])
end

"""
    Unipartite{T <: Any} <: Partiteness{T}

A unipartite set of species is represented by a single set of species, called
`margin` internally. Both set of species are represented as `Vector{T}`, with a
few specific constraints:

1. `T` cannot be a `Number` (*i.e.* nodes must have names, or be other objects)
2. All species in `margin` must be unique
"""
struct Unipartite{T <: Any} <: Partiteness{T}
    margin::Vector{T}
    function Unipartite(margin::Vector{T}) where {T <: Any}
        if T <: Number
            throw(ArgumentError("The nodes IDs in a Unipartite set cannot be numbers"))
        end
        if ~allunique(margin)
            throw(ArgumentError("The species in a unipartite network must be unique"))
        end
        return new{T}(margin)
    end
end

@testitem "We can construct a unipartite species set with symbols" begin
    set = Unipartite([:a, :b, :c])
    @test richness(set) == 3
end

@testitem "We can construct a unipartite species set with strings" begin
    set = Unipartite(["a", "b", "c"])
    @test richness(set) == 3
end

@testitem "We cannot construct a unipartite set with non-unique species" begin
    @test_throws ArgumentError Unipartite([:a, :b, :b])
end

@testitem "We cannot construct a unipartite set with integer-valued species" begin
    @test_throws ArgumentError Unipartite([1, 2, 3, 4])
end

"""
    Probabilistic{T <: AbstractFloat} <: Interactions{T}

Probabilistic interactions are represented (internally) as a sparse matrix of
floating point values. The values *must* be in the unit interval for the type to
be valid.
"""
struct Probabilistic{T <: AbstractFloat} <: Interactions{T}
    edges::SparseMatrixCSC{T}
    function Probabilistic(edges::SparseMatrixCSC{T}) where {T <: AbstractFloat}
        if any(0.0 .< edges .< 1.0)
            throw(ArgumentError("Probabilities must be in the unit interval"))
        end
        return new{T}(edges)
    end
end

@testitem "We cannot construct probabilistic matrices with values outside the unit interval" begin
    @test_throws ArgumentError Probabilistic(rand(Float32, (2, 2)).*2.0)
end

"""
    Quantitative{T <: Number} <: Interactions{T}

Quantitative interactions are represented (internally) as a sparse matrix of numbers.
"""
struct Quantitative{T <: Number} <: Interactions{T}
    edges::SparseMatrixCSC{T}
end

"""
    Binary{Bool} <: Interactions{Bool}

Binary interactions are represented (internally) as a sparse matrix of Boolean
values.
"""
struct Binary{Bool} <: Interactions{Bool}
    edges::SparseMatrixCSC{Bool}
end

@testitem "We can construct a unipartite probabilistic network" begin
    nodes = Unipartite([:a, :b, :c])
    edges = Binary(rand(Bool, (3,3)))
    N = SpeciesInteractionNetwork(nodes, edges)
    @test richness(N) == 3
    @test species(N) == [:a, :b, :c]
end