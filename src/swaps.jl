# Swaps for deterministic networks

"""
This function will take two matrices and one constraint, and return whether the
first matrix is a valid permutation of the second one under a given constraint.
"""
function is_valid(a, x, c)
  @assert c ∈ [:degree, :generality, :vulnerability, :fill]
  # all unconstrained permutations are valid
  if c == :fill
    return true
  end
  # marginals of original matrix
  xr = sum(x, 2)
  xc = sum(x, 1)
  # marginals of permutation attempt
  ar = sum(a, 2)
  ac = sum(a, 1)
  # compute
  same_r = xr == ar
  same_c = xc == ac
  if c == :degree
    return same_r & same_c
  end
  if c == :generality
    return same_r
  end
  if c == :vulnerability
    return same_c
  end
  # this should never happen
  return true
end

"""
Performs an inner swap
"""
function inner_swap(x::Array{Bool, 2}; constraint::Symbol=:degree)
  @assert constraint ∈ [:degree, :generality, :vulnerability, :fill]

  # Generate a first attempt
  attempt = reshape(x[shuffle(eachindex(x))], size(x))
  valid = is_valid(attempt, x, constraint)

  while (! valid)
    attempt = reshape(x[shuffle(eachindex(x))], size(x))
    valid = is_valid(attempt, x, constraint)
  end

  return attempt
end

"""
Swaps a network while enforcing a constraint on degree distribution.

Arguments:
1. `N`, an `UnipartiteNetwork`

Keywords:
- `constraint`: can be `:degree`, `:generality`, `:vulnerability`, or `:fill`
- `swapsize`: the size of the sub-matrix to swap (defaults to 3)
- `n`: the number of sub-matrices to swap (defaults to 3000)
"""
function swap(N::UnipartiteNetwork; constraint::Symbol=:degree, swapsize::Int64=3, n::Int64=3000)
  # we want to have the same number of species as the required swap size
  @assert minimum(size(N)) > swapsize

  Y = copy(N.A)

  doneswaps = 0
  while doneswaps < n
    species = sample(1:richness(N), swapsize, replace=false)
    if sum(Y[species, species]) >= 2
      Y[species, species] = inner_swap(Y[species, species], constraint=constraint)
      doneswaps += 1
    end
  end

  return UnipartiteNetwork(Y)
end
