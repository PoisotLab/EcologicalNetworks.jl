function check_bipartiteness(A)
  return true
end

function check_unipartiteness(A)
  @assert size(A,1) == size(A,2)
end

function check_bipartiteness(A, T, B)
  check_bipartiteness(A)
  check_name_vector(T)
  check_name_vector(B)
  @assert eltype(T) == eltype(B)
  @assert length(unique(vcat(T,B))) == sum(size(A))
  @assert length(T) == size(A,1)
  @assert length(B) == size(A,2)
end

function check_unipartiteness(A, S)
  check_unipartiteness(A)
  check_name_vector(S)
  @assert length(S) == size(A,1)
end

function check_name_vector(N)
  @assert length(N) == length(unique(N))
end

function check_probability_values(A)
  @assert minimum(A) >= zero(eltype(A))
  @assert maximum(A) <= one(eltype(A))
end
