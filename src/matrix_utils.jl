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
   return map((x) -> Float64(rand(Bernoulli(x))), A)
end

#=
Set all probabilities to 1.0
=#
function make_binary(A::Array{Float64,2})
   return map((x) -> x>0.0 ? 1.0 : 0.0, A)
end

#=
Sets the diagonal to 0
=#
function nodiag(A::Array{Float64,2})
   return A .* (1.0 .- eye(Float64, size(A)[1]))
end
