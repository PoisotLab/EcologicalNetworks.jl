# Swaps for deterministic networks

"""
This function will take two matrices and one constraint, and return whether the
first matrix is a valid permutation of the second one under a given constraint.
"""
function is_valid(a, x, c)
  @assert c ∈ [:degree, :generality, :vulnerability, :fill]
  # all unconstrained permutations are valid
  if c == :fill
    return sum(a) == sum(x)
  end
  # other cases
  if c == :degree
    return (sum(a, 1) == sum(x, 1)) & (sum(a, 2) == sum(x, 2))
  end
  if c == :generality
    return sum(a, 2) == sum(x, 2)
  end
  if c == :vulnerability
    return sum(a, 1) == sum(x, 1)
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

  Y = copy(N)

  doneswaps = 0
  while doneswaps < n
    species = sample(1:richness(N), swapsize, replace=false)
    if sum(Y[species, species]) >= 2
      keep = Y[species, species]
      Y[species, species] = inner_swap(Y[species, species], constraint=constraint)
      if prod(degree(Y) .> 0)
        doneswaps += 1
      else
        Y[species, species] = keep # restore and restart
      end

    end
  end

  return Y
end

"""
Swaps a bipartite network while enforcing a constraint on degree distribution.
"""
function swap(N::BipartiteNetwork; constraint::Symbol=:degree, swapsize::Int64=3, n::Int64=3000)
  # we want to have the same number of species as the required swap size
  @assert minimum(size(N)) > swapsize

  Y = copy(N)

  doneswaps = 0
  while doneswaps < n
    sp_row = sample(1:size(N.A, 1), swapsize, replace=false)
    sp_col = sample(1:size(N.A, 2), swapsize, replace=false)
    if sum(Y[sp_row, sp_col]) >= 2
      keep = Y[sp_row, sp_col]
      Y[sp_row, sp_col] = inner_swap(Y[sp_row, sp_col], constraint=constraint)
      if prod(degree(Y) .> 0)
        doneswaps += 1
      else
        Y[sp_row, sp_col] = keep # restore and restart
      end
    end
  end

  return Y
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
  @assert prod(degree(N).>0)
  # TODO make parallel
  return map(x -> swap(N, constraint=constraint, swapsize=swapsize, n=n), 1:r)
end
