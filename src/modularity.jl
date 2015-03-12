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
  kij = (ki .* kj') ./ ((2*m)*(2*m))
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
New type
=#
type Partition
  A::Array{Float64, 2}
  L::Array{Int64, 1}
  Q::Float64
end

#=
Propagate labels edge by edge
=#
function propagate_labels(A::Array{Float64, 2}, kmax::Int64, smax::Int64)
  # Make a list of labels
  n_lab = maximum(size(A))
  L = vec(round(Int64, linspace(1, n_lab, n_lab)))
  # Prepare the null model
  m = links(A)
  aij = A ./ (2*m)
  ki = degree_out(A)
  kj = degree_in(A)
  kij = (ki .* kj') ./ ((2*m)*(2*m))
  nmod = aij .- kij
  best_Q = sum(nmod .* (L .== L')) # Initial modularity
  # Update
  no_increase = 0
  for k in 1:kmax
    i = rand(1:size(A)[1])
    j = rand(1:size(A)[2])
    if rand() <= A[i,j]
      cj = L[j]
      L[j] = L[i]
      tentative_Q = sum(nmod .* (L .== L')) # Tentative modularity
      if tentative_Q < best_Q
        L[j] = cj
        no_increase = no_increase + 1
      else
        no_increase = 0
        best_Q = tentative_Q
      end
    end
    if no_increase == smax
      break
    end
    if length(unique(L)) == 1
      break
    end
  end
  return Partition(A, L, best_Q)
end

#=
Wrapper
=#
function modularity(A::Array{Float64, 2}; replicates=100, kmax=0, smax=0, verbose=false)
  # Get parameters
  if kmax == 0
    kmax = 2 * prod(size(A))
    smax = maximum([round(Int64, kmax/5) 1])
  end
  # First trial
  best_partition = propagate_labels(A, kmax, smax)
  if verbose
    info(string("Modularity run 1 of ", replicates, ": Q=", best_partition.Q))
  end
  for trial in 2:replicates
    trial_partition = propagate_labels(A, kmax, smax)
    if trial_partition.Q > best_partition.Q
      best_partition = trial_partition
    end
    if verbose
      info(string("Modularity run $trial of $replicates -- Q=", best_partition.Q))
    end
  end
  return best_partition
end
