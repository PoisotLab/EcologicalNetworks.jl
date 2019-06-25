"""
    null1(N::BinaryNetwork)

Given a network `N`, `null1(N)` returns a network with the same dimensions, where
every interaction happens with a probability equal to the connectance of `N`.

Note that this does not guarantee that the network is not degenerate, so the
output of this analysis *should* be filtered using `isdegenerate`, or passed to
`simplify`. The output of this approach is *always* a probabilistic network of
the same partiteness as the original network.

#### References

Fortuna, M.A., Bascompte, J., 2006. Habitat loss and the structure of
plantanimal mutualistic networks. Ecol. Lett. 9, 281–286.
https://doi.org/10.1111/j.1461-0248.2005.00868.x
"""
function null1(N::BinaryNetwork)
    return linearfilter(N; α=[0.0, 0.0, 0.0, 1.0])
end

"""
    null3(N::BinaryNetwork; dims::Integer=1)

Given a network `N`, `null3(N)` returns a matrix with the same dimensions,
where every interaction happens with a probability equal to the out-degree
(`dims=1`) or to the in-degree (`dims=2`, number of predecessors) of each
species, divided by the total number of possible predecessors/successors.

Note that this does not guarantee that the network is not degenerate, so the
output of this analysis *should* be filtered using `isdegenerate`, or passed to
`simplify`. The output of this approach is *always* a probabilistic network of
the same partiteness as the original network.

#### References

Poisot, T., Stanko, M., Miklisová, D., Morand, S., 2013. Facultative and
obligate parasite communities exhibit different network properties. Parasitology
140, 1340–1345. https://doi.org/10.1017/S0031182013000851
"""
function null3(N::BinaryNetwork; dims::Integer=1)
  @assert dims ∈ [1,2]
  α = dims == 1 ? [0.0, 1.0, 0.0, 0.0] : [0.0, 0.0, 1.0, 0.0]
  return linearfilter(N; α=α)
end

"""
    null2(N::BinaryNetwork)

Given a network `N`, `null2(N)` returns a network with the same dimensions, where
every interaction happens with a probability equal to the degree of each
species.

Note that this does not guarantee that the network is not degenerate, so the
output of this analysis *should* be filtered using `isdegenerate`, or passed to
`simplify`. The output of this approach is *always* a probabilistic network of
the same partiteness as the original network.

#### References

Bascompte, J., Jordano, P., Melian, C.J., Olesen, J.M., 2003. The nested
assembly of plant-animal mutualistic networks. PNAS 100, 9383–9387.
https://doi.org/10.1073/pnas.1633576100
"""
function null2(N::BinaryNetwork)
  return linearfilter(N; α=[0.0, 0.5, 0.5, 0.0])
end


"""
    null4(N::BinaryNetwork)

Given a matrix `A`, `null4(A)` returns a matrix with the same dimensions, where
every interaction happens with a probability equal to the product of the degree
of each species.
"""
function null4(N::BinaryNetwork)
  Afiltered = sum(N, dims=1) .* sum(N, dims=2) ./ sum(N)^2
  ReturnType = typeof(N) <: AbstractBipartiteNetwork ? BipartiteProbabilisticNetwork : UnipartiteProbabilisticNetwork
  return ReturnType(Afiltered, species_objects(N)...)
end
