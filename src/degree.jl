"""
Expected number of outgoing degrees
"""
function degree_out(N::EcoNetwork)
  return vec(sum(N.A, 2))
end

"""
Expected number of ingoing degrees
"""
function degree_in(N::EcoNetwork)
  return vec(sum(N.A, 1))
end

""" Expected degree
"""
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
