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
    a = L(intersect(Xi,Yi))
    b = L(Xi)-a
    c = L(Yi)-a
    return @NT(a=a, b=b, c=c)
end

function βos{T<:UnipartiteNetwork}(X::T, Y::T)
    core = intersect(X,Y)
    Xi = X[species(core)]
    Yi = Y[species(core)]
    a = L(intersect(Xi,Yi))
    b = L(Xi)-a
    c = L(Yi)-a
    return @NT(a=a, b=b, c=c)
end

function βwn{T<:BinaryNetwork}(X::T, Y::T)
    a = L(intersect(X,Y))
    c = L(X)-a
    b = L(Y)-a
    return @NT(a=a, b=b, c=c)
end
