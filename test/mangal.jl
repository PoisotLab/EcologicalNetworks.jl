module MangalTestConversions
    using EcologicalNetworks
    using Mangal
    using Test

    # random network
    N = first(networks("name" => "hadfield_2014_20140201_1007"))

    @test typeof(convert(UnipartiteNetwork, N)) <: UnipartiteNetwork

end
