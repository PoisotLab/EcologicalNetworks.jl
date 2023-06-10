interactions(N::SpeciesInteractionNetwork) = [int for int in N]

@testitem "We can get the interactions in a network" begin
    nodes = Bipartite([:A, :B], [:c, :d])
    edges = Binary([true true; false true])
    N = SpeciesInteractionNetwork(nodes, edges)
    @test interactions(N) == [(:A, :c, true), (:A, :d, true), (:B, :d, true)]
end