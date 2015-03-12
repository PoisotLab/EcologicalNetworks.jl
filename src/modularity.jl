#=
Modularity function
=#
function Q(A::Array{Float64, 2}, L::Array{Int64, 1})
  if length(unique(L)) == 1
    return 0.0
  end
  m = sum(A)
  aij = A ./ (2*m)
  ki = mapslices(sum, A, 1) ./ (2*m)
  kj = mapslices(sum, A, 2) ./ (2*m)
  kij = (ki .* kj)
  return sum((aij .- kij) .* (L .== L'))
end

#=
Propagate labels edge by edge
=#
function propagate_labels(A::Array{Float64, 2}; iters=1000)
  # Make a list of labels
  n_lab = maximum(size(A))
  L = vec(round(Int64, linspace(1, n_lab, n_lab)))
  # Update
  for iter in 1:iters
    i = rand(1:size(A)[1])
    j = rand(1:size(A)[2])
    if rand() <= A[i,j]
      cQ = Q(A, L)
      cj = L[j]
      L[j] = L[i]
      nQ = Q(A, L)
      if nQ < cQ
        # TODO decide when to stop
        L[j] = cj
      end
    end
    if length(unique(L)) == 1
      break
    end
  end
  return (A, L)
end

#=
New type
=#
type Partition
  A::Array{Float64, 2}
  L::Array{Int64, 1}
  Q::Float64
end

#=
Wrapper
=#
function modularity(A::Array{Float64, 2}; replicates=10, iters=1000)
  best_Q = 0.0
  for trial in 1:replicates
    trial_partition = propagate_labels(A, iters=iters)
    trial_Q = Q(trial_partition...)
    if trial_Q > new_Q
      new_Q = trial_Q
      partition = Partition(A, L, trial_Q)
    end
  end
  return partition
end
