"""
    βs(X::T, Y::T) where {T<:BinaryNetwork}

Components of β-diversity as measured on species.
"""
function βs(X::T, Y::T) where {T<:BinaryNetwork}
    a = richness(intersect(X,Y))
    b = richness(Y)-a
    c = richness(X)-a
    return (a=a, b=b, c=c)
end


"""
Overlapping species (bipartite)
"""
function βos(X::T, Y::T) where {T<:BipartiteNetwork}
    core = intersect(X,Y)
    Xi = X[species(core; dims=1),species(core; dims=2)]
    Yi = Y[species(core; dims=1),species(core; dims=2)]
    a = links(intersect(Xi,Yi))
    b = links(Xi)-a
    c = links(Yi)-a
    return (a=a, b=b, c=c)
end


"""
Overlapping species (unipartite)
"""
function βos(X::T, Y::T) where {T<:UnipartiteNetwork}
    core = intersect(X,Y)
    Xi = X[species(core)]
    Yi = Y[species(core)]
    a = links(intersect(Xi,Yi))
    b = links(Xi)-a
    c = links(Yi)-a
    return (a=a, b=b, c=c)
end


"""
Whole network
"""
function βwn(X::T, Y::T) where {T<:BinaryNetwork}
    a = links(intersect(X,Y))
    c = links(X)-a
    b = links(Y)-a
    return (a=a, b=b, c=c)
end
