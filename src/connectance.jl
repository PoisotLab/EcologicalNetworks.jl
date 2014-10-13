function links(A::Array{Float64,2})
   return sum(A)
end

function links_var(A::Array{Float64,2})
   return sum(A.*(1.-A))
end

function connectance(A::Array{Float64,2})
   return links(A) / prod(size(A))
end
