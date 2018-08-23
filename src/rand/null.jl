"""
    null1(N::BinaryNetwork)

Given a matrix `A`, `null1(A)` returns a matrix with the same dimensions,
where every interaction happens with a probability equal to the connectance of
`A`.
"""
function null1(N::BinaryNetwork)
    return linearfilter(N; α=[0.0, 0.0, 0.0, 1.0])
end

"""
    null3out(N::BinaryNetwork)

Given a matrix `A`, `null3out(A)` returns a matrix with the same dimensions,
where every interaction happens with a probability equal to the out-degree
(number of successors) of each species, divided by the total number of possible
successors.
"""
function null3out(N::BinaryNetwork)
  return linearfilter(N; α=[0.0, 1.0, 0.0, 0.0])
end

"""
    null3in(N::BinaryNetwork)

Given a matrix `A`, `null3in(A)` returns a matrix with the same dimensions,
where every interaction happens with a probability equal to the in-degree
(number of predecessors) of each species, divided by the total number of
possible predecessors.
"""
function null3in(N::BinaryNetwork)
  return linearfilter(N; α=[0.0, 0.0, 1.0, 0.0])
end

"""
    null2(N::BinaryNetwork)

Given a matrix `A`, `null2(A)` returns a matrix with the same dimensions, where
every interaction happens with a probability equal to the degree of each
species.
"""
function null2(N::BinaryNetwork)
  return linearfilter(N; α=[0.0, 0.5, 0.5, 0.0])
end
