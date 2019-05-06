"""
    βs(X::T, Y::T) where {T<:BinaryNetwork}

Components of β-diversity as measured on species.

#### References

Koleff, P., Gaston, K.J., Lennon, J.J., 2003. Measuring beta diversity for
presence–absence data. Journal of Animal Ecology 72, 367–382.
https://doi.org/10.1046/j.1365-2656.2003.00710.x
"""
function βs(X::T, Y::T) where {T<:BinaryNetwork}
    a = richness(intersect(X,Y))
    b = richness(Y)-a
    c = richness(X)-a
    return (a=a, b=b, c=c)
end


"""
    βos(X::T, Y::T) where {T<:BipartiteNetwork}

Overlapping species (bipartite)

#### References

Canard, E.F., Mouquet, N., Mouillot, D., Stanko, M., Miklisova, D., Gravel, D.,
2014. Empirical evaluation of neutral interactions in host-parasite networks.
The American Naturalist 183, 468–479. https://doi.org/10.1086/675363

Poisot, T., Canard, E., Mouillot, D., Mouquet, N., Gravel, D., 2012. The
dissimilarity of species interaction networks. Ecol. Lett. 15, 1353–1361.
https://doi.org/10.1111/ele.12002

Poisot, T., Cirtwill, A.R., Cazelles, K., Gravel, D., Fortin, M.-J., Stouffer,
D.B., 2016. The structure of probabilistic networks. Methods in Ecology and
Evolution 7, 303–312. https://doi.org/10.1111/2041-210X.12468
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
    βos(X::T, Y::T) where {T<:UnipartiteNetwork}

Overlapping species (unipartite)

#### References

Canard, E.F., Mouquet, N., Mouillot, D., Stanko, M., Miklisova, D., Gravel, D.,
2014. Empirical evaluation of neutral interactions in host-parasite networks.
The American Naturalist 183, 468–479. https://doi.org/10.1086/675363

Poisot, T., Canard, E., Mouillot, D., Mouquet, N., Gravel, D., 2012. The
dissimilarity of species interaction networks. Ecol. Lett. 15, 1353–1361.
https://doi.org/10.1111/ele.12002

Poisot, T., Cirtwill, A.R., Cazelles, K., Gravel, D., Fortin, M.-J., Stouffer,
D.B., 2016. The structure of probabilistic networks. Methods in Ecology and
Evolution 7, 303–312. https://doi.org/10.1111/2041-210X.12468
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
    βwn(X::T, Y::T) where {T<:BinaryNetwork}

Whole network

#### References

Canard, E.F., Mouquet, N., Mouillot, D., Stanko, M., Miklisova, D., Gravel, D.,
2014. Empirical evaluation of neutral interactions in host-parasite networks.
The American Naturalist 183, 468–479. https://doi.org/10.1086/675363

Poisot, T., Canard, E., Mouillot, D., Mouquet, N., Gravel, D., 2012. The
dissimilarity of species interaction networks. Ecol. Lett. 15, 1353–1361.
https://doi.org/10.1111/ele.12002

Poisot, T., Cirtwill, A.R., Cazelles, K., Gravel, D., Fortin, M.-J., Stouffer,
D.B., 2016. The structure of probabilistic networks. Methods in Ecology and
Evolution 7, 303–312. https://doi.org/10.1111/2041-210X.12468
"""
function βwn(X::T, Y::T) where {T<:BinaryNetwork}
    a = links(intersect(X,Y))
    c = links(X)-a
    b = links(Y)-a
    return (a=a, b=b, c=c)
end
