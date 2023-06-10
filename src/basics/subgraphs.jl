function subgraph(N::SpeciesInteractionNetwork{<:Unipartite{T}, <:Interactions}, nodes::Vector{T}) where {T}
    indexes = indexin(nodes, species(N))
    if any(isnothing.(indexes))
        throw(ArgumentError("Impossible to induce a subgraph from species that are not in the graph"))
    end
    indexes = convert(Vector{Integer}, indexes)
    edges = typeof(N.edges).name.wrapper(N.edges.edges[indexes, indexes])
    nodes = typeof(N.nodes).name.wrapper(N.nodes.margin[indexes])
    return SpeciesInteractionNetwork(nodes, edges)
end

subgraph(N::SpeciesInteractionNetwork{<:Unipartite, <:Interactions}, ::Colon) = subgraph(N, species(N))

@testitem "We can induce a subgraph from a unipartite network" begin
    nodes = Unipartite([:A, :B, :C])
    edges = Binary(rand(Bool, (3, 3)))
    N = SpeciesInteractionNetwork(nodes, edges)
    S = subgraph(N, [:A, :B])
    @test richness(S) == 2
    for i in interactions(S)
        @test N[i[1],i[2]] == S[i[1],i[2]]
    end
end

@testitem "We can induce a subgraph from a unipartite network using :" begin
    nodes = Unipartite([:A, :B, :C])
    edges = Binary(rand(Bool, (3, 3)))
    N = SpeciesInteractionNetwork(nodes, edges)
    S = subgraph(N, :)
    @test richness(S) == richness(N)
    for i in interactions(S)
        @test N[i[1],i[2]] == S[i[1],i[2]]
    end
end

@testitem "We cannot induce a subgraph if one of the nodes does not exist" begin
    nodes = Unipartite([:A, :B, :C])
    edges = Binary(rand(Bool, (3, 3)))
    N = SpeciesInteractionNetwork(nodes, edges)
    @test_throws ArgumentError subgraph(N, [:D, :E])
end

function subgraph(N::SpeciesInteractionNetwork{<:Bipartite{T}, <:Interactions}, top::Vector{T}, bottom::Vector{T}) where {T}
    topindexes = indexin(top, species(N,1))
    botindexes = indexin(bottom, species(N,2))
    if any(isnothing.(topindexes))
        throw(ArgumentError("Impossible to induce a subgraph from species that are not in the graph"))
    end
    if any(isnothing.(botindexes))
        throw(ArgumentError("Impossible to induce a subgraph from species that are not in the graph"))
    end
    topindexes = convert(Vector{Integer}, topindexes)
    botindexes = convert(Vector{Integer}, botindexes)
    edges = typeof(N.edges).name.wrapper(N.edges.edges[topindexes, botindexes])
    topnodes = N.nodes.top[topindexes]
    botnodes = N.nodes.bottom[botindexes]
    nodes = typeof(N.nodes).name.wrapper(topnodes, botnodes)
    return SpeciesInteractionNetwork(nodes, edges)
end

subgraph(N::SpeciesInteractionNetwork{<:Bipartite{T}, <:Interactions}, ::Colon, bottom::Vector{T}) where {T} = subgraph(N, species(N,1), bottom)
subgraph(N::SpeciesInteractionNetwork{<:Bipartite{T}, <:Interactions}, top::Vector{T}, ::Colon) where {T} = subgraph(N, top, species(N,2))
subgraph(N::SpeciesInteractionNetwork{<:Bipartite, <:Interactions}, ::Colon, ::Colon) = subgraph(N, species(N,1), species(N,2))

@testitem "We can induce a subgraph from a bipartite network" begin
    nodes = Bipartite([:A, :B, :C], [:a, :b])
    edges = Binary(rand(Bool, (length(nodes.top), length(nodes.bottom))))
    N = SpeciesInteractionNetwork(nodes, edges)
    S = subgraph(N, [:A, :C], [:b])
    @test richness(S) == 3
    for i in interactions(S)
        @test N[i[1],i[2]] == S[i[1],i[2]]
    end
end

@testitem "We can induce a subgraph from a bipartite network using : (top)" begin
    nodes = Bipartite([:A, :B, :C], [:a, :b])
    edges = Binary(rand(Bool, (length(nodes.top), length(nodes.bottom))))
    N = SpeciesInteractionNetwork(nodes, edges)
    S = subgraph(N, :, species(N,2))
    @test richness(S) == richness(N)
    for i in interactions(S)
        @test N[i[1],i[2]] == S[i[1],i[2]]
    end
end

@testitem "We can induce a subgraph from a bipartite network using : (bottom)" begin
    nodes = Bipartite([:A, :B, :C], [:a, :b])
    edges = Binary(rand(Bool, (length(nodes.top), length(nodes.bottom))))
    N = SpeciesInteractionNetwork(nodes, edges)
    S = subgraph(N, species(N,1), :)
    @test richness(S) == richness(N)
    for i in interactions(S)
        @test N[i[1],i[2]] == S[i[1],i[2]]
    end
end

@testitem "We can induce a subgraph from a bipartite network using : (both)" begin
    nodes = Bipartite([:A, :B, :C], [:a, :b])
    edges = Binary(rand(Bool, (length(nodes.top), length(nodes.bottom))))
    N = SpeciesInteractionNetwork(nodes, edges)
    S = subgraph(N, :, :)
    @test richness(S) == richness(N)
    for i in interactions(S)
        @test N[i[1],i[2]] == S[i[1],i[2]]
    end
end

@testitem "We cannot induce a bipartite subgraph if one of the nodes does not exist" begin
    nodes = Bipartite([:A, :B, :C], [:a, :b])
    edges = Binary(rand(Bool, (length(nodes.top), length(nodes.bottom))))
    N = SpeciesInteractionNetwork(nodes, edges)
    @test_throws ArgumentError subgraph(N, [:A, :B] ,[:c])
    @test_throws ArgumentError subgraph(N, [:D, :A], [:a])
end