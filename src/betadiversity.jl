"""
**Partition of network similarity**

The sets are, respectively

- `a`, expected number of common interactions
- `b`, expected number of interactions unique to B
- `c`, expected number of interactions unique to A

Note that *all* values are `Float64`, since when dealing with probabilistic
events, the expected cardinality of each set is not integers.

"""
type BetaSet
  a::Float64
  b::Float64
  c::Float64
end

import Base.sum

function sum(S::BetaSet)
  return S.a + S.b + S.c
end

"""
**Expected network similarity**

    betadiversity(N1::EcoNetwork, N2::EcoNetwork)

Note that this is only meaningful to apply this function when the two matrices
have the same species at the same position! If this is not the case, a
`BoundsError` will be thrown.

This function will return a `BetaSet`, which is then used by the function to
actually measure the beta-diversity. This package uses the approach of Koleff et
a. (2003).

Koleff, P., Gaston, K. J. and Lennon, J. J. (2003), Measuring beta diversity for
presence–absence data. Journal of Animal Ecology, 72: 367–382. doi:
10.1046/j.1365-2656.2003.00710.x

"""
function betadiversity(N1::EcoNetwork, N2::EcoNetwork)

  # The two networks must have the same size
  if size(N1) != size(N2)
    throw(BoundsError())
  end

  # The two networks must be of the same type
  if typeof(N1) != typeof(N2)
    throw(TypeError(:betadiversity, "Both networks must have the same type", typeof(N1), typeof(N2)))
  end

  # We need to know how values are stored internally
  itype = typeof(N1) <: DeterministicNetwork ? Bool : Float64
    unity = one(itype)

    a = sum(N1.A .* N2.A)
    b = sum((unity .- N1.A) .* N2.A)
    c = sum(N1.A .* (unity .- N2.A))
    return BetaSet(a, b, c)
  end

  #=
  TODO
  Give the reference in the docstring of each function
  =#

  """ Whittaker measure of beta-diversity """
  function whittaker(S::BetaSet)
    return sum(S)/((S.a + sum(S))/2.0) - 1.0
  end

  """ Sorensen measure of beta-diversity """
  function sorensen(S::BetaSet)
    return (2.0*S.a)/(S.a + sum(S))
  end

  """ Jaccard measure of beta-diversity """
  function jaccard(S::BetaSet)
    return S.a/sum(S)
  end

  """ Gaston measure of beta-diversity """
  function gaston(S::BetaSet)
    return (S.b+S.c)/sum(S)
  end

  """ Williams measure of beta-diversity """
  function williams(S::BetaSet)
    return minimum(vec([S.b S.c]))/sum(S)
  end

  """ Lande measure of beta-diversity """
  function lande(S::BetaSet)
    return (S.b + S.c)/2.0
  end

  """ Ruggiero measure of beta-diversity """
  function ruggiero(S::BetaSet)
    return (S.a)/(S.a + S.c)
  end

  """ Harte-Kinzig measure of beta-diversity """
  function hartekinzig(S::BetaSet)
    return 1.0 - (2.0 * S.a)/(S.a + sum(S))
  end

  """ Harrison measure of beta-diversity """
  function harrison(S::BetaSet)
    return minimum(vec([S.b S.c]))/(minimum(vec([S.b S.c])) + S.a)
  end
