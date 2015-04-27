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

import Base.sum

function sum(S::BetaSet)
  return S.a + S.b + S.c
end

@doc """ Measure the expected network similarity

Note that this is only meaningful to apply this function when the two matrices
have the same species at the same position! If this is note the case, a
`BoundsError` will be thrown.

This function will return a `BetaSet`, which is then used by the function to
actually measure the beta-diversity. This package uses the approach of Koleff et a. (2003).

**References**

1. Koleff, P., Gaston, K. J. and Lennon, J. J. (2003), Measuring beta diversity
for presence–absence data. Journal of Animal Ecology, 72: 367–382. doi:
10.1046/j.1365-2656.2003.00710.x

""" ->
function betadiversity(A::Array{Float64,2}, B::Array{Float64,2})
  if size(A) != size(B)
    throw(BoundsError())
  end
  a = sum(A .* B)
  b = sum((1 .- A) .* B)
  c = sum(A .* (1 .- B))
  return BetaSet(a, b, c)
end

#=
TODO
Give the reference in the docstring of each function
=#

@doc """ Whittaker measure of beta-diversity """ ->
function whittaker(S::BetaSet)
  return sum(S)/((S.a + sum(S))/2.0) - 1.0
end

@doc """ Sorensen measure of beta-diversity """ ->
function sorensen(S::BetaSet)
  return (2.0*S.a)/(S.a + sum(S))
end

@doc """ Jaccard measure of beta-diversity """ ->
function jaccard(S::BetaSet)
  return S.a/sum(S)
end

@doc """ Gaston measure of beta-diversity """ ->
function gaston(S::BetaSet)
  return (S.b+S.c)/sum(S)
end

@doc """ Williams measure of beta-diversity """ ->
function williams(S::BetaSet)
  return minimum(vec([S.b S.c]))/sum(S)
end

@doc """ Lande measure of beta-diversity """ ->
function lande(S::BetaSet)
  return (S.b + S.c)/2.0
end

@doc """ Ruggiero measure of beta-diversity """ ->
function ruggiero(S::BetaSet)
  return (S.a)/(S.a + S.c)
end

@doc """ Harte-Kinzig measure of beta-diversity """ ->
function hartekinzig(S::BetaSet)
  return 1.0 - (2.0 * S.a)/(S.a + sum(S))
end

@doc """ Harrison measure of beta-diversity """ ->
function harrison(S::BetaSet)
  return minimum(vec([S.b S.c]))/(minimum(vec([S.b S.c])) + S.a)
end
