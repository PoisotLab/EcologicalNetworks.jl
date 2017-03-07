# Swaps for deterministic networks

"""
This function will take two matrices and one constraint, and return whether the
first matrix is a valid permutation of the second one under a given constraint.
"""
function is_valid(a, x, c)
  @assert c ∈ [:both, :rows, :columns, :none]
  # all unconstrained permutations are valid
  if c == :none
    return true
  end
  # marginals of original matrix
  xr = sum(x, 2)
  xc = sum(x, 1)
  # marginals of permutation attempt
  ar = sum(x, 2)
  ac = sum(x, 1)
  # compute
  same_r = xr == ar
  same_c = xc == ac
  if c == :both
    return same_r & same_c
  end
  if c == :rows
    return same_r
  end
  if c == :columns
    return same_c
  end
  # this should never happen
  return true
end

function swap(x, constraint=:both)
  @assert constraint ∈ [:both, :rows, :columns, :none]

  # Generate a first attempt
  attempt = reshape(x[shuffle(eachindex(x))], size(x))
  still_searching = ! is_valid(attempt, x, constraint) # TODO write th `is_valid` function

  while still_searching
    attempt = reshape(x[shuffle(eachindex(x))], size(x))
    still_searching = ! is_valid(attempt, x, constraint)
  end

  return attempt
end
