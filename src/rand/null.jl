"""
    null1(N::BinaryNetwork)

Given a network `N`, `null1(N)` returns a network with the same dimensions, where
every interaction happens with a probability equal to the connectance of `N`.

Note that this does not guarantee that the network is not degenerate, so the
output of this analysis *should* be filtered using `is_degenerate`, or passed to
`simplify`. The output of this approach is *always* a probabilistic network of
the same partiteness as the original network.
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
output of this analysis *should* be filtered using `is_degenerate`, or passed to
`simplify`. The output of this approach is *always* a probabilistic network of
the same partiteness as the original network.
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
output of this analysis *should* be filtered using `is_degenerate`, or passed to
`simplify`. The output of this approach is *always* a probabilistic network of
the same partiteness as the original network.
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
output of this analysis *should* be filtered using `is_degenerate`, or passed to
`simplify`. The output of this approach is *always* a probabilistic network of
the same partiteness as the original network.
"""
function null2(N::BinaryNetwork)
  return linearfilter(N; α=[0.0, 0.5, 0.5, 0.0])
end
