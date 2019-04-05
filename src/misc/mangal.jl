function get_all_interactions(n::MangalNetwork)
    page_size = 200
    network_interactions = MangalInteraction[]
    interactions_to_get = count(MangalInteraction, "network_id" => n.id)
    pages_to_do = convert(Int64, ceil(interactions_to_get/page_size))
    for page in 1:pages_to_do
        paging_query = ["page" => "$(page-1)", "count" => "page_size"]
        append!(network_interactions, Mangal.interactions(n, paging_query...))
    end
    return network_interactions
end

import Base.convert

"""
    convert(::Type{UnipartiteNetwork}, n::MangalNetwork; resolution::Type=MangalNode)

Returns a `UnipartiteNetwork` object representation of the `MangalNetwork`
passed as its first argument. The optional keyword `resolution` (can be
`MangalNode` or `MangalReferenceTaxon`) is determined to use which level of
aggregation should be used. The default (`MangalNode`) is raw data, and
`MangalReferenceTaxon` is the cleaned version.
"""
function convert(::Type{UnipartiteNetwork}, n::MangalNetwork; resolution::Type=MangalNode)
    resolution ∈ [MangalNode, MangalReferenceTaxon] || throw(ArgumentError("The resolution argument can only be MangalNode or MangalReferenceTaxon - you used $(resolution)"))

    network_interactions = get_all_interactions(n)
    all_object_nodes = resolution[]

    for i in network_interactions
        push!(all_object_nodes, resolution == MangalNode ? i.from : i.from.taxon)
        push!(all_object_nodes, resolution == MangalNode ? i.to : i.to.taxon)
    end

    object_nodes = unique(all_object_nodes)
    A = zeros(Bool, (length(object_nodes),length(object_nodes)))
    N = UnipartiteNetwork(A, object_nodes)
    for i in network_interactions
        if i.strength != 0
            t_from = resolution == MangalReferenceTaxon ? i.from.taxon : i.from
            t_to   = resolution == MangalReferenceTaxon ? i.to.taxon : i.to
            N[t_from, t_to] = true
        end
    end

    return N
end
