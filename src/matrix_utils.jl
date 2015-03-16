#=
Makes a bipartite network unipartite
=#
function make_unipartite(A::Array{Float64,2})
  S = sum(size(A))
  B = zeros(Float64,(S,S))
  B[1:size(A)[1],size(A)[1]+1:S] = A
  return B
end

#=
Generates a random binary matrix based on a probabilistic one
=#
function make_bernoulli(A::Array{Float64,2})
  return float64(rand(size(A)) .<= A)
  # This next line will work once 0.4 becomes the current release. For now, the
  # above works, but with a deprecation warning when used in the release
  # version.
  # return map(Float64, rand(size(A)) .<= A)
end

#=
Sets the diagonal to 0
=#
function nodiag(A::Array{Float64,2})
  return A .* (1.0 .- eye(Float64, size(A)[1]))
end

#=
Use a threshold
=#
function make_threshold(A::Array{Float64,2}, k::Float64)
  # Check the values of k
  if (k < 0.0) | (k >= 1.0)
    throw(DomainError())
  end
  # Return if not
  return map((x) -> x>k ? 1.0 : 0.0, A)
end

#=
Set all probabilities to 1.0
=#
function make_binary(A::Array{Float64,2})
  return make_threshold(A, 0.0)
end
