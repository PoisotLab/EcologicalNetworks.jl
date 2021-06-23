function check_bipartiteness(A)
  return true
end

function check_unipartiteness(A)
  size(A,1) == size(A,2) || throw(ArgumentError("The matrix for a unipartite network must be square (yours has size $(size(A)))"))
end

function check_bipartiteness(A, T, B)
  check_bipartiteness(A)
  check_name_vector(T)
  check_name_vector(B)
  eltype(T) == eltype(B) || throw(ArgumentError("The species in a bipartite network levels must have the same type (you gave $(eltype(T)) and $(eltype(B)))"))
  length(unique(vcat(T,B))) == sum(size(A)) || throw(ArgumentError("Species names cannot be shared between the levels of a bipartite network"))
  length(T) == size(A,1) || throw(ArgumentError("The length of top-level species names must match matrix size ($(length(T)) v. $(size(A,1)))"))
  length(B) == size(A,2) || throw(ArgumentError("The length of bottom-level species names must match matrix size ($(length(B)) v. $(size(A,2)))"))
end

function check_unipartiteness(A, S)
  check_unipartiteness(A)
  check_name_vector(S)
  length(S) == size(A,1) || throw(ArgumentError("The length of species names must match matrix size ($(length(S)) v. $(size(A,1)))"))
end

function check_name_vector(N)
  allunique(N) || throw(ArgumentError("The names of species must be unique"))
end

function check_probability_values(A)
  minimum(A) >= zero(eltype(A)) || throw(ArgumentError("The probabilities must be at least 0.0"))
  maximum(A) <= one(eltype(A)) || throw(ArgumentError("The probabilities must be at most 1.0"))
end
