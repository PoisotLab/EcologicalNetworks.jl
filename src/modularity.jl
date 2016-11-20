#=
Partition, a type to store a community partition
=#
"""
Type to store a community partition

This type has three elements:

- `A`, the probability matrix
- `L`, the array of (integers) module labels
- `Q`, if needed, the modularity value

"""
type Partition
    A::Array{Float64, 2}
    L::Array{Int64, 1}
    Q::Float64
end

#=
Modularity function
=#
"""
Q -- a measure of modularity

This measures Barber's bipartite modularity based on a matrix and a list of
module labels.
"""
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

"""
Q -- a measure of modularity

This measures Barber's bipartite modularity based on a `Partition` object, and
update the object in the proccess.
"""
function Q(P::Partition)
  P.Q = Q(P.A, P.L)
  P.Q
end

#=
Realized modularity function
=#
"""
Qr -- a measure of realized modularity

Measures Poisot's realized modularity, based on a  a matrix and a list of module
labels. Realized modularity takes values in the [0;1] interval, and is the
proportion of interactions established *within* modules.

Note that in some situations, `Qr` can be *lower* than 0. This reflects a
partition in which more links are established between than within modules.
"""
function Qr(A::Array{Float64, 2}, L::Array{Int64, 1})
  if length(unique(L)) == 1
    return 0.0
  end
  W = sum(A .* (L .== L'))
  E = links(A)
  return 2.0 * (W/E) - 1.0
end


"""
Qr -- a measure of realized modularity

Measures Poisot's realized modularity, based on a `Partition` object.
"""
function Qr(P::Partition)
  return Qr(P.A, P.L)
end

"""
A **very** experimental label propagation method for probabilistic networks

This function is a take on the usual LP method for community detection. Instead
of updating labels by taking the most frequent in the neighbors, this algorithm
takes each interaction, and transfers the label across it with a probability
equal to the probability of the interaction. It is therefore *not* generalizable
for non-probabilistic networks.

The other pitfall is that there is a need to do a *large* number of iterations
to get to a good partition. This method is also untested.
"""
function propagate_labels(A::Array{Float64, 2})
    # Make a list of labels
    n_lab = maximum(size(A))
    L = collect(1:n_lab)
    # Prepare the null model
    m = links(A)
    aij = A ./ (2*m)
    ki = degree_out(A)
    kj = degree_in(A)
    kij = (ki .* kj') ./ ((2*m)*(2*m))
    nmod = aij .- kij
    best_Q = sum(nmod .* (L .== L')) # Initial modularity
    improved = true
    # Update
    while improved | (best_Q == 1.0)

        # Pick a side of the matrix at random.
        # This can be either 1 (rows) or 2 (columns)
        # In practice, it means that we work on either the matrix
        # or the transposed matrix
        side = sample([1, 2], 1)[1]
        B = side == 1 ? A : A'

        # Within this side, we will pick one species at random
        # Note that this makes the code working for both unipartite
        # and bipartite networks.
        i = rand(1:size(B, 1))

        # For this species, we pick its neighbour's labels
        i_neighbours = vec(B[i,:])

        if rand() <= B[i,j]
            cj = L[j]
            L[j] = L[i]
            tentative_Q = sum(nmod .* (L .== L')) # Tentative modularity
            if tentative_Q < best_Q
                improved = false
                L[j] = cj
            else
                improved = true
                best_Q = tentative_Q
            end
        end
    end
    return Partition(A, L, best_Q)
end

"""

This function is a wrapper for the modularity code. The number of replicates is
the number of times the modularity optimization should be run.

Non-keywords arguments:

1. `A`, probability matrix

Keywords arguments:

1. `replicates`, defaults to `100`
1. `kmax`, defaults to twice the matrix size, number of propagations to do
2. `smax`, maximum number of steps without an increase in modularity before LP stops

**Keep in mind** that this approach has not been thoroughly tested. The
*measure* of modularity works, but the *optimization routine* is not
guaranteed to give robust/correct results.

"""
function modularity(A::Array{Float64, 2}; replicates=100, kmax=0, smax=0)
  #=
  Parameters for LP

  By default, 2*s^2 steps are done. This may or may not be sufficient.

  =#
  if kmax == 0
    kmax = 2 * prod(size(A))
    smax = maximum([round(Int64, kmax/5) 1])
  end
  # First trial
  best_partition = propagate_labels(A, kmax, smax)
  for trial in 2:replicates
    trial_partition = propagate_labels(A, kmax, smax)
    if trial_partition.Q > best_partition.Q
      best_partition = trial_partition
    end
  end
  Q(best_partition)
  return best_partition
end

