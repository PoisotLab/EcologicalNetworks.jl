function trophicspecies(N::T; clustering_function::Function=EAJS) where {T <: UnipartiteNetwork}
    similarities = clustering_function(N)
end
