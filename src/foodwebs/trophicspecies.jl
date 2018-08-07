function trophicspecies(N::T; clustering_function::Function=EAJS) where {T <: UnipartiteNetwork}

    similarities = clustering_function(N)

    # TODO make a matrix based on overlap

end
