import Base.shuffle

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
end

"""
Performs an inner swap
"""
function inner_swap(x::AbstractMatrix{Bool}; constraint::Symbol=:degree)
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
function shuffle(N::UnipartiteNetwork; constraint::Symbol=:degree, swapsize::Int64=3, n::Int64=3000)
  # we want to have the same number of species as the required swap size
  @assert minimum(size(N)) > swapsize

  Y = copy(N).A

  doneswaps = 0
  while doneswaps < n
    species = sample(1:richness(N), swapsize, replace=false)
    if sum(Y[species, species]) >= 2
      keep = Y[species, species]
      Y[species, species] = inner_swap(Y[species, species], constraint=constraint)
      if prod(vec(sum(Y,1)).*vec(sum(Y,2)) .> 0)
        doneswaps += 1
      else
        Y[species, species] = keep # restore and restart
      end
    end
  end

  return typeof(N)(Y, species_objects(N)...)
end

"""
**Generate a single permutation of a network**

    swap(N::BipartiteNetwork; constraint::Symbol=:degree, swapsize::Int64=3, n::Int64=3000)

Swaps a bipartite network while enforcing a constraint on degree distribution.
See the documentation for `swaps` for the complete explanation of arguments.
"""
function shuffle(N::BipartiteNetwork; constraint::Symbol=:degree, swapsize::Int64=3, n::Int64=3000)
  # we want to have the same number of species as the required swap size
  @assert minimum(size(N)) > swapsize

  Y = copy(N).A

  doneswaps = 0
  while doneswaps < n
    sp_row = sample(1:size(Y, 1), swapsize, replace=false)
    sp_col = sample(1:size(Y, 2), swapsize, replace=false)
    if sum(Y[sp_row, sp_col]) >= 2
      keep = Y[sp_row, sp_col]
      Y[sp_row, sp_col] = inner_swap(Y[sp_row, sp_col], constraint=constraint)
      if prod(vec(sum(Y,1)).*vec(sum(Y,2)) .> 0)
        doneswaps += 1
      else
        Y[sp_row, sp_col] = keep # restore and restart
      end
    end
  end

  return typeof(N)(Y, species_objects(N)...)
end
