#=
Modularity function
=#
function Q(A::Array{Float64, 2}, L::Array{Int64, 1})
  if length(unique(L)) == 1
    return 0.0
  end
  m = links(A)
  aij = A ./ (2*m)
  ki = degree_out(A)
  kj = degree_in(A)
  kij = (ki .* kj') ./ (m*m)
  return sum((aij .- kij) .* (L .== L'))
end

#=
Realized modularity function
=#
function Qr(A::Array{Float64, 2}, L::Array{Int64, 1})
  if length(unique(L)) == 1
    return 0.0
  end
  W = sum(A .* (L .== L'))
  E = links(A)
  return 2.0 * (W/E) - 1.0
end

#=
Propagate labels edge by edge
=#
function propagate_labels(A::Array{Float64, 2}, kmax::Int64, smax::Int64)
  # Make a list of labels
  n_lab = maximum(size(A))
  L = vec(round(Int64, linspace(1, n_lab, n_lab)))
  # Update
  no_increase = 0
  for k in 1:kmax
    i = rand(1:size(A)[1])
    j = rand(1:size(A)[2])
    if rand() <= A[i,j]
      cQ = Q(A, L)
      cj = L[j]
      L[j] = L[i]
      nQ = Q(A, L)
      if nQ < cQ
        L[j] = cj
        no_increase = no_increase + 1
      end
    end
    if no_increase == smax
      break
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
function modularity(A::Array{Float64, 2}; replicates=100, kmax=0, smax=0)
  # Get parameters
  if kmax == 0
    kmax = 2 * prod(size(A))
    smax = maximum([round(Int64, kmax/5) 1])
  end
  best_Q = 0.0
  # First trial
  trial_partition = propagate_labels(A, kmax, smax)
  partition = Partition(A, trial_partition[2], Q(trial_partition...))
  for trial in 2:replicates
    trial_partition = propagate_labels(A, kmax, smax)
    trial_Q = Q(trial_partition...)
    if trial_Q > best_Q
      best_Q = trial_Q
      partition = Partition(A, trial_partition[2], trial_Q)
    end
  end
  return partition
end
