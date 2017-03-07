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
Swaps a unipartite network while enforcing a constraint on degree distribution.
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

"""
Swaps a bipartite network while enforcing a constraint on degree distribution.
"""
function swap(N::BipartiteNetwork; constraint::Symbol=:degree, swapsize::Int64=3, n::Int64=3000)
  # we want to have the same number of species as the required swap size
  @assert minimum(size(N)) > swapsize

  Y = copy(N.A)

  doneswaps = 0
  while doneswaps < n
    sp_row = sample(1:size(N.A, 1), swapsize, replace=false)
    sp_col = sample(1:size(N.A, 2), swapsize, replace=false)
    if sum(Y[sp_row, sp_col]) >= 2
      Y[sp_row, sp_col] = inner_swap(Y[sp_row, sp_col], constraint=constraint)
      doneswaps += 1
    end
  end

  return BipartiteNetwork(Y)
end

"""
Generates randomized networks based on some constraints on degre distributions.

By default, this method will look for random (x, x) sub-matrices, where x is
given by the `swapsize` keyword, and shuffle them. There are four possible
constraints:

| value            | meaning                | proba equivalent |
|:-----------------|:-----------------------|:-----------------|
| `:degree`        | both in and out degree | `null2`          |
| `:generality`    | only out degree        | `null3out`       |
| `:vulnerability` | only in degree         | `null3in`        |
| `:fill`          | only number of links   | `null1`          |

Arguments:
1. `N`, a `DeterministicNetwork`
2. `r`, the number of randomized networks to generate

Keywords:
- `constraint`: can be `:degree`, `:generality`, `:vulnerability`, or `:fill`
- `swapsize`: the size of the square sub-matrix to swap (defaults to 3)
- `n`: the number of sub-matrices to swap (defaults to 3000)
"""
function swaps(N::DeterministicNetwork, r::Int64; constraint::Symbol=:degree, swapsize::Int64=3, n::Int64=3000)
  @assert r > 0
  # TODO make parallel
  return map(x -> swap(N, constraint=constraint, swapsize=swapsize, n=n), 1:r)
end
