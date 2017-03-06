# Swaps for deterministic networks

function is_valid(a, x, c)
  @assert c ∈ [:both, :rows, :columns, :none]
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
