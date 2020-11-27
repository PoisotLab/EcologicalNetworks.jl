import Base.sum

"""
    sum(N::AbstractEcologicalNetwork; dims=nothing)

This function will return the sum of all interactions in the network. For
quantitative networks, this is the sum of interaction strengths. For binary
networks, this is the number of interactions. For probabilistic networks, this
is the expected number of realized interactions.

Optionally, one can give the argument dims, simular to the native `sum`, which
computes the sum of the interactions for the lower (`dims=2`) or higher
(`dims=1`) level.

#### References

- Delmas, E., Besson, M., Brice, M.-H., Burkle, L.A., Dalla Riva, G.V., Fortin,
  M.-J., Gravel, D., Guimarães, P.R., Hembry, D.H., Newman, E.A., Olesen, J.M.,
  Pires, M.M., Yeakel, J.D., Poisot, T., 2018. Analysing ecological networks of
  species interactions. Biological Reviews 112540.
  https://doi.org/10.1111/brv.12433

- Dunne, J.A., 2006. The Network Structure of Food Webs, in: Dunne, J.A.,
  Pascual, M. (Eds.), Ecological Networks: Linking Structure and Dynamics.
  Oxford University Press, pp. 27–86.

- Martinez, N.D., 1992. Constant Connectance in Community Food Webs. The
  American Naturalist 139, 1208–1218.
"""
function sum(N::AbstractEcologicalNetwork; dims::Union{Nothing,Int}=nothing)
    @assert isnothing(dims) || dims == 1 || dims == 2
    isnothing(dims) && return sum(N.edges)
    return sum(N.edges, dims=dims)
end

"""
    links(N::BinaryNetwork)

Number of non-zero interactions in a deterministic network.

#### References

- Delmas, E., Besson, M., Brice, M.-H., Burkle, L.A., Dalla Riva, G.V., Fortin,
  M.-J., Gravel, D., Guimarães, P.R., Hembry, D.H., Newman, E.A., Olesen, J.M.,
  Pires, M.M., Yeakel, J.D., Poisot, T., 2018. Analysing ecological networks of
  species interactions. Biological Reviews 112540.
  https://doi.org/10.1111/brv.12433

- Dunne, J.A., 2006. The Network Structure of Food Webs, in: Dunne, J.A.,
  Pascual, M. (Eds.), Ecological Networks: Linking Structure and Dynamics.
  Oxford University Press, pp. 27–86.

- Martinez, N.D., 1992. Constant Connectance in Community Food Webs. The
  American Naturalist 139, 1208–1218.
"""
function links(N::BinaryNetwork)
    return count(!iszero, N.edges)
end

"""
    links(N::QuantitativeNetwork)

Number of non-zero interactions in a quantitative network (use `sum` to get the
sum of interaction strengths).

#### References

- Delmas, E., Besson, M., Brice, M.-H., Burkle, L.A., Dalla Riva, G.V., Fortin,
  M.-J., Gravel, D., Guimarães, P.R., Hembry, D.H., Newman, E.A., Olesen, J.M.,
  Pires, M.M., Yeakel, J.D., Poisot, T., 2018. Analysing ecological networks of
  species interactions. Biological Reviews 112540.
  https://doi.org/10.1111/brv.12433

- Dunne, J.A., 2006. The Network Structure of Food Webs, in: Dunne, J.A.,
  Pascual, M. (Eds.), Ecological Networks: Linking Structure and Dynamics.
  Oxford University Press, pp. 27–86.

- Martinez, N.D., 1992. Constant Connectance in Community Food Webs. The
  American Naturalist 139, 1208–1218.
"""
function links(N::QuantitativeNetwork)
    return count(!iszero, N.edges)
end

"""
    links(N::ProbabilisticNetwork)

Expected number of interactions in a probabilistic network. To get the number of
interactions that have a non-zero probability, use *e.g.* `links(N>0.0)`.

#### References

- Poisot, T., Cirtwill, A.R., Cazelles, K., Gravel, D., Fortin, M.-J., Stouffer,
  D.B., 2016. The structure of probabilistic networks. Methods in Ecology and
  Evolution 7, 303–312. https://doi.org/10.1111/2041-210X.12468
"""
function links(N::ProbabilisticNetwork)
    return sum(N)
end

"""
    links_var(N::ProbabilisticNetwork)

Expected variance of the number of links for a probabilistic network.

#### References

Poisot, T., Cirtwill, A.R., Cazelles, K., Gravel, D., Fortin, M.-J., Stouffer,
D.B., 2016. The structure of probabilistic networks. Methods in Ecology and
Evolution 7, 303–312. https://doi.org/10.1111/2041-210X.12468
"""
function links_var(N::ProbabilisticNetwork)
   return sum(N.A .* (1 .- N.A))
end

"""
    connectance(N::AbstractEcologicalNetwork)

Number of links divided by the number of possible interactions. In unipartite
networks, this is ``L/S^2``. In bipartite networks, this is ``L/(T × B)``. It is
worth noting that while the maximal connectance is always 1 (i.e. the graph is
complete), the minimum value (assuming that the network is not degenerate) is
*not* 0. Instead, the minimum number of interactions in a unipartite network is
`S-1`, and in a bipartite network it is `max(T,B)`.

Connectance can therefore be transformed between 0 and 1, using the following
approach: let `m` be the minimum number of interactions, and Co be the measured
connectance, then the corrected value is `(Co-m)/(1-m)`. To our best knowledge,
this is not standard practice, and therefore is not suggested as a function in
the package.

#### References

Delmas, E., Besson, M., Brice, M.-H., Burkle, L.A., Dalla Riva, G.V., Fortin,
M.-J., Gravel, D., Guimarães, P.R., Hembry, D.H., Newman, E.A., Olesen, J.M.,
Pires, M.M., Yeakel, J.D., Poisot, T., 2018. Analysing ecological networks of
species interactions. Biological Reviews 112540.
https://doi.org/10.1111/brv.12433

Dunne, J.A., 2006. The Network Structure of Food Webs, in: Dunne, J.A., Pascual,
M. (Eds.), Ecological Networks: Linking Structure and Dynamics. Oxford
University Press, pp. 27–86.

Martinez, N.D., 1992. Constant Connectance in Community Food Webs. The American
Naturalist 139, 1208–1218.
"""
function connectance(N::AbstractEcologicalNetwork)
    return links(N) / (richness(N; dims=1)*richness(N; dims=2))
end

"""
    linkage_density(N::AbstractEcologicalNetwork)

Number of links divided by species richness.

#### References

Delmas, E., Besson, M., Brice, M.-H., Burkle, L.A., Dalla Riva, G.V., Fortin,
M.-J., Gravel, D., Guimarães, P.R., Hembry, D.H., Newman, E.A., Olesen, J.M.,
Pires, M.M., Yeakel, J.D., Poisot, T., 2018. Analysing ecological networks of
species interactions. Biological Reviews 112540.
https://doi.org/10.1111/brv.12433

Dunne, J.A., 2006. The Network Structure of Food Webs, in: Dunne, J.A., Pascual,
M. (Eds.), Ecological Networks: Linking Structure and Dynamics. Oxford
University Press, pp. 27–86.
"""
function linkage_density(N::AbstractEcologicalNetwork)
    return links(N) / richness(N)
end

"""
    connectance_var(N::ProbabilisticNetwork)

Expected variance of the connectance for a probabilistic matrix, measured as the
variance of the number of links divided by the squared size of the matrix.

#### References

Poisot, T., Cirtwill, A.R., Cazelles, K., Gravel, D., Fortin, M.-J., Stouffer,
D.B., 2016. The structure of probabilistic networks. Methods in Ecology and
Evolution 7, 303–312. https://doi.org/10.1111/2041-210X.12468
"""
function connectance_var(N::ProbabilisticNetwork)
   return links_var(N) / (prod(size(N))^2)
end
