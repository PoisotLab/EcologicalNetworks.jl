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
    return Set{T}(N.nodes.top[succ_idx])
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
    @test false
end