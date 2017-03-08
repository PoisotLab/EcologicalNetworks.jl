"""
Expected number of outgoing degrees.
"""
function degree_out(N::EcoNetwork)
  return vec(sum(N.A, 2))
end

"""
Expected number of ingoing degrees.
"""
function degree_in(N::EcoNetwork)
  return vec(sum(N.A, 1))
end

"""
This function returns the sum of the in and out degree of a unipartite graph
"""
function degree(N::Unipartite)
  return degree_in(N) .+ degree_out(N)
end

"""
This function returns the total degree of nodes in a bipartite network. This
is a concatenation of the out degree and the in degrees of nodes on both sizes
"""
function degree(N::Bipartite)
    return degree(make_unipartite(N))
end

function degree_out_var(N::ProbabilisticNetwork)
  return mapslices(a_var, N.A, 2)
end

function degree_in_var(N::ProbabilisticNetwork)
  return mapslices(a_var, N.A, 1)'
end

function degree_var(N::UnipartiteProbaNetwork)
  return degree_out_var(N) .+ degree_in_var(N)
end

#=
Specificity
=#

"""
Paired Differences Index for specificity. This function will range the values
of each row, so that the strongest link has a value of one.
"""
function pdi{T}(x::Array{T, 1})
    s = reverse(sort(x))
    s = s ./ maximum(s)
    p = s .- s[1]
    return sum(p[2:end])/(length(s)-1)
end


"""
Resource-range measure of specificity in deterministic networks.
"""
function specificity(N::DeterministicNetwork)
    A = map(Int64, N.A)
    return vec(mapslices(pdi, A, 2))
end

"""
Paired Differences Index of specificity in quantitative networks.
"""
function specificity(N::QuantitativeNetwork)
    return vec(mapslices(pdi, N.A, 2))
end
