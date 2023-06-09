function successors(N::SpeciesInteractionNetwork{Bipartite{T}, <:Interactions}, sp::T) where {T}
    if sp in N.nodes.bottom
        return Set{T}()
    end
    if !(sp in species(N,1))
        throw(ArgumentError("The species $(sp) is not in the network"))
    end
    succ_idx = findall(!iszero, N[sp,:])
    if isempty(succ_idx)
        return Set{T}()
    end
    return Set{T}(N.nodes.bottom[succ_idx])
end

function successors(N::SpeciesInteractionNetwork{Unipartite{T}, <:Interactions}, sp::T) where {T}
    if !(sp in species(N))
        throw(ArgumentError("The species $(sp) is not in the network"))
    end
    succ_idx = findall(!iszero, N[sp,:])
    if isempty(succ_idx)
        return Set{T}()
    end
    return Set{T}(N.nodes.margin[succ_idx])
end

@testitem "We cannot look for successors of a species not in a network" begin
    edges = Binary(rand(Bool, (4, 3)))
    nodes = Bipartite([:A, :B, :C, :D], [:a, :b, :c])
    N = SpeciesInteractionNetwork(nodes, edges)
    @test_throws ArgumentError successors(N, :X)
end

@testitem "Bottom-level species have no successors" begin
    edges = Binary(rand(Bool, (4, 3)))
    nodes = Bipartite([:A, :B, :C, :D], [:a, :b, :c])
    N = SpeciesInteractionNetwork(nodes, edges)
    @test isempty(successors(N, :a))
end

@testitem "We can correctly identify successors in bipartite networks" begin
    M = [true true true; true true false; false false true]
    edges = Binary(M)
    nodes = Bipartite([:A, :B, :C], [:a, :b, :c])
    N = SpeciesInteractionNetwork(nodes, edges)
    @test successors(N, :A) == Set([:a, :b, :c])
    @test successors(N, :B) == Set([:a, :b])
    @test successors(N, :C) == Set([:c])
end

@testitem "We can correctly identify successors in unipartite networks" begin
    M = [true true true; true true false; false false true]
    edges = Binary(M)
    nodes = Unipartite([:A, :B, :C])
    N = SpeciesInteractionNetwork(nodes, edges)
    @test successors(N, :A) == Set([:A, :B, :C])
    @test successors(N, :B) == Set([:A, :B])
    @test successors(N, :C) == Set([:C])
end

function predecessors(N::SpeciesInteractionNetwork{Bipartite{T}, <:Interactions}, sp::T) where {T}
    if sp in N.nodes.top
        return Set{T}()
    end
    if !(sp in species(N,2))
        throw(ArgumentError("The species $(sp) is not in the network"))
    end
    succ_idx = findall(!iszero, N[:,sp])
    if isempty(succ_idx)
        return Set{T}()
    end
    return Set{T}(N.nodes.top[succ_idx])
end

function predecessors(N::SpeciesInteractionNetwork{Unipartite{T}, <:Interactions}, sp::T) where {T}
    if !(sp in species(N))
        throw(ArgumentError("The species $(sp) is not in the network"))
    end
    succ_idx = findall(!iszero, N[:,sp])
    if isempty(succ_idx)
        return Set{T}()
    end
    return Set{T}(N.nodes.margin[succ_idx])
end

@testitem "We cannot look for predecessors of a species not in a network" begin
    edges = Binary(rand(Bool, (4, 3)))
    nodes = Bipartite([:A, :B, :C, :D], [:a, :b, :c])
    N = SpeciesInteractionNetwork(nodes, edges)
    @test_throws ArgumentError predecessors(N, :X)
end

@testitem "Top-level species have no predecessors" begin
    edges = Binary(rand(Bool, (4, 3)))
    nodes = Bipartite([:A, :B, :C, :D], [:a, :b, :c])
    N = SpeciesInteractionNetwork(nodes, edges)
    @test isempty(predecessors(N, :A))
end

@testitem "We can correctly identify predecessors in bipartite networks" begin
    M = [true true true; true true false; false false true]
    edges = Binary(M)
    nodes = Bipartite([:A, :B, :C], [:a, :b, :c])
    N = SpeciesInteractionNetwork(nodes, edges)
    @test predecessors(N, :a) == Set([:A, :B])
    @test predecessors(N, :b) == Set([:A, :B])
    @test predecessors(N, :c) == Set([:A, :C])
end

@testitem "We can correctly identify predecessors in unipartite networks" begin
    M = [true true true; true true false; false false true]
    edges = Binary(M)
    nodes = Unipartite([:A, :B, :C])
    N = SpeciesInteractionNetwork(nodes, edges)
    @test predecessors(N, :A) == Set([:A, :B])
    @test predecessors(N, :B) == Set([:A, :B])
    @test predecessors(N, :C) == Set([:A, :C])
end