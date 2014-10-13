using Distributions

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
function make_binary(A::Array{Float64,2})
   return float(map((x) -> rand(Bernoulli(x)), A))
end

#=

Sets the diagonal to 0

=#
function nodiag(A::Array{Float64,2})
   return A .* (1.0 .- eye(Float64, size(A)[1]))
end

