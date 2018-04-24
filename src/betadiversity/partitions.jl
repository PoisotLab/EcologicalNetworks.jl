function βs{T<:BinaryNetwork}(X::T, Y::T)
    a = richness(intersect(X,Y))
    b = richness(Y)-a
    c = richness(X)-a
    return @NT(a=a, b=b, c=c)
end


function βos{T<:BipartiteNetwork}(X::T, Y::T)
    core = intersect(X,Y)
    Xi = X[species(core,1),species(core,2)]
    Yi = Y[species(core,1),species(core,2)]
    a = links(intersect(Xi,Yi))
    b = links(Xi)-a
    c = links(Yi)-a
    return @NT(a=a, b=b, c=c)
end

function βos{T<:UnipartiteNetwork}(X::T, Y::T)
    core = intersect(X,Y)
    Xi = X[species(core)]
    Yi = Y[species(core)]
    a = links(intersect(Xi,Yi))
    b = links(Xi)-a
    c = links(Yi)-a
    return @NT(a=a, b=b, c=c)
end

function βwn{T<:BinaryNetwork}(X::T, Y::T)
    a = links(intersect(X,Y))
    c = links(X)-a
    b = links(Y)-a
    return @NT(a=a, b=b, c=c)
end
