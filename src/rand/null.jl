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
    null3out(N::BinaryNetwork)

Given a network `N`, `null3out(N)` returns a network with the same dimensions,
where every interaction happens with a probability equal to the out-degree
(number of successors) of each species, divided by the total number of possible
successors.

Note that this does not guarantee that the network is not degenerate, so the
output of this analysis *should* be filtered using `isdegenerate`, or passed to
`simplify`. The output of this approach is *always* a probabilistic network of
the same partiteness as the original network.

#### References

Poisot, T., Stanko, M., Miklisová, D., Morand, S., 2013. Facultative and
obligate parasite communities exhibit different network properties. Parasitology
140, 1340–1345. https://doi.org/10.1017/S0031182013000851
"""
function null3out(N::BinaryNetwork)
  return linearfilter(N; α=[0.0, 1.0, 0.0, 0.0])
end

"""
    null3in(N::BinaryNetwork)

Given a network `N`, `null3in(N)` returns a matrix with the same dimensions,
where every interaction happens with a probability equal to the in-degree
(number of predecessors) of each species, divided by the total number of
possible predecessors.

Note that this does not guarantee that the network is not degenerate, so the
output of this analysis *should* be filtered using `isdegenerate`, or passed to
`simplify`. The output of this approach is *always* a probabilistic network of
the same partiteness as the original network.

#### References

Poisot, T., Stanko, M., Miklisová, D., Morand, S., 2013. Facultative and
obligate parasite communities exhibit different network properties. Parasitology
140, 1340–1345. https://doi.org/10.1017/S0031182013000851
"""
function null3in(N::BinaryNetwork)
  return linearfilter(N; α=[0.0, 0.0, 1.0, 0.0])
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
