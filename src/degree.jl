#=

Degree for all species

=#

function degree_out(A::Array{Float64,2})
   return sum(A, 2)
end

function degree_in(A::Array{Float64,2})
   return sum(A, 1)'
end

function degree(A::Array{Float64,2})
   return degree_in(A) .+ degree_out(A)
end

function degree_out_var(A::Array{Float64,2})
   return mapslices(a_var, A, 2)
end

function degree_in_var(A::Array{Float64,2})
   return mapslices(a_var, A, 1)'
end

function degree_var(A::Array{Float64,2})
   return degree_out_var(A) .+ degree_in_var(A)
end
