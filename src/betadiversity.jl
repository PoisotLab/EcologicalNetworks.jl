@doc """ Partition of network similarity

The sets are, respectively

- `a`, expected number of common interactions
- `b`, expected number of interactions unique to B
- `c`, expected number of interactions unique to A

Note that *all* values are `Float64`, since when dealing with probabilistic
events, the expected cardinality of each set is not integers.

""" ->
type BetaSet
  a::Float64
  b::Float64
  c::Float64
end

@doc """ Measure the expected network similarity

Note that this is only meaningful to apply this function when the two matrices
have the same species at the same position! If this is note the case, a
`BoundsError` will be thrown.

This function will return a `BetaSet`, which is then used by the function to
actually measure the beta-diversity.

""" ->
function betadiversity(A::Array{Float64,2}, B::Array{Float64,2})
  if size(A) != size(B)
    # TODO Custom error type?
    throw(BoundsError())
  end
  a = sum(A .* B)
  b = sum((1 .- A) .* B)
  c = sum(A .* (1 .- B))
  return BetaSet(a, b, c)
end

@doc """ Whittaker measure of beta-diversity """ ->
function whittaker(S::BetaSet)
  return (S.a + S.b + S.c)/(((S.a + S.b + S.c)+S.a)/2.0) - 1.0
end

@doc """ Sorensen measure of beta-diversity """ ->
function sorensen(S::BetaSet)
  return (2.0*S.a)/((S.a + S.b + S.c)+S.a)
end

@doc """ Jaccard measure of beta-diversity """ ->
function jaccard(S::BetaSet)
  return S.a/(S.a + S.b + S.c)
end
