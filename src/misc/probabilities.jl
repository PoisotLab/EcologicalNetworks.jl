"""
Quite crude way of checking that a number is a probability

The two steps are

1. The number should be of the `Float64` type
2. The number should belong to [0.0,1.0]
"""
function checkprob(p::T) where {T<:AbstractFloat}
	(0.0 <= p <= 1.0) || throw(ArgumentError("The value p=$(p) is not a probability"))
	return nothing
end


"""
Expected value of a single Bernoulli event

Simply f(p): p
"""
function i_esp(p::Float64)
    checkprob(p)
	return p
end

"""
Variance of a single Bernoulli event

f(p): p(1-p)
"""
function i_var(p::Float64)
    checkprob(p)
	return p*(1.0-p)
end


"""
Variance of a series of additive Bernoulli events

f(p): ∑(p(1-p))
"""
function a_var(p::Array{Float64})
	return reduce(+, map(i_var, p))
end

"""
Variance of a series of multiplicative Bernoulli events
"""
function m_var(p::Array{Float64})
	# LOLWUT
	return reduce(*, map((x) -> i_var(x) + i_esp(x)*i_esp(x), p)) - reduce(*, map((x) -> i_esp(x)*i_esp(x), p))
end
