@doc """ Expected number of links for a probabilistic matrix
""" ->
function links(A::Array{Float64,2})
   return sum(A)
end

@doc """ Expected variance of the number of links for a probabilistic matrix
""" ->
function links_var(A::Array{Float64,2})
   return sum(A.*(1.-A))
end

@doc """ Expected connectance for a probabilistic matrix, measured as the number
of expected links, divided by the size of the matrix.
""" ->
function connectance(A::Array{Float64,2})
   return links(A) / prod(size(A))
end

@doc """ Expected variance of the connectance for a probabilistic matrix,
measured as the variance of the number of links divided by the squared size of
the matrix.
""" ->
function connectance_var(A::Array{Float64,2})
   return links_var(A) / (prod(size(A))^2)
end
