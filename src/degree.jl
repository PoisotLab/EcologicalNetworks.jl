#=

Degree for all species

=#

@doc """ Expected number of outgoing degrees
""" ->
function degree_out(A::Array{Float64,2})
  return vec(sum(A, 2))
end

@doc """ Expected number of ingoing degrees
""" ->
function degree_in(A::Array{Float64,2})
  return vec(sum(A, 1))
end

@doc """ Expected degree
""" ->
function degree(A::Array{Float64,2})
  @assert size(A)[1] == size(A)[2]
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
