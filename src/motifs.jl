""" Internal motif calculations

The two arguments are `A` the adjacency matrix (probabilistic) and `m` the motif
adjacency matrix (0.0 or 1.0 only). The two matrices must have the same size.
The function returns a *vectorized* probability of each interaction being in the
right state for the motif, *i.e.* P if m is 1, and 1 - P if m is 0.

"""
function motif_internal(A::Array{Float64, 2}, m::Array{Float64, 2})
  # The motif structure can only be 0 or 1
  @assert sort(unique(m)) == vec([0.0 1.0]) || unique(m) == vec([0.0]) || unique(m) == vec([1.0])
  # The motif structure must have the same size than the partial adjacency matrix
  @assert size(A) == size(m)
  # Change the motif structure into a multiplication structure
  b = copy(m)
  b[m .== 0.0] = 1.0
  b[m .== 1.0] = 2.0 .* A[m .== 1.0]
  return vec(b .- A)
end

""" Probability that a group of species form a given motif """
function motif_p(A::Array{Float64, 2}, m::Array{Float64, 2})
  return prod(motif_internal(A, m))
end

""" Variance that a group of species form a given motif """
function motif_v(A::Array{Float64, 2}, m::Array{Float64, 2})
  return m_var(motif_internal(A, m))
end

""" Motif counter

This function will go through all k-permutations of `A` to measure the
probability of each induced subgraph being an instance of the motif given by
`m` (the square adjacency matrix of the motif, with 0 and 1).

"""
function count_motifs(A::Array{Float64, 2}, m::Array{Float64, 2})
   # Both should be square matrices -- this makes my life easier
   @assert size(A)[1] == size(A)[2]
   @assert size(m)[1] == size(m)[2]
   # How many nodes in the graph?
   nmax = size(A)[1]
   # How many nodes in the motif?
   nmot = size(m)[1]
   # The motif must be no larger than A
   @assert nmax >= nmot
   # Define the sets
   single_probas = Float64[]
   for c in combinations(1:nmax, nmot)
      for p in permutations(c)
         #= FIXME Growing the array is slow, do some algebra you idiot =#
         push!(single_probas, motif_p(A[vec(p), vec(p)], m))
      end
   end
   return single_probas
end

""" Expected number of a given motif """
function motif(A::Array{Float64, 2}, m::Array{Float64, 2})
  return sum(float(count_motifs(A, m)))
end

""" Expected variance of a given motif """
function motif_var(A::Array{Float64, 2}, m::Array{Float64, 2})
  return a_var(float(count_motifs(A, m)))
end
