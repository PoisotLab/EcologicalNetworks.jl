#=
This macro checks that the value passed to it is a float, is at least 0,
and at most 1

It is called internally by the i_var and i_esp function to make sure that
the arguments are actually probabilities
=#
"""
Quite crude way of checking that a number is a probability

The two steps are

1. The number should be of the `Float64` type -- if not, will yield a `TypeError`
2. The number should belong to [0,1] -- if not, will throw a `DomainError`

"""
macro checkprob(p)
	quote
		# Check the correct type
		if typeof($p) != Float64
			throw(TypeError("Probabilities should be floating point numbers", "@checkprob", Float64, typeof($p)))
		end
		# Check the values
		if ($p < 0.0) | ($p > 1.0)
			Logging.warn("Probabilities must be in [0.0;1.0]")
			throw(DomainError())
		end
	end
end


#=
Esperance of a Bernoulli process (p)
=#
"""Expected value of a single Bernoulli event

Simply f(p): p
"""
function i_esp(p::Float64)
	@checkprob p
	return p
end


#=
Variance of a Bernoulli process (p(1-p))
=#
"""Variance of a single Bernoulli event

f(p): p(1-p)
"""
function i_var(p::Float64)
  @checkprob p
  return p*(1.0-p)
end


#=
Variance of additive events
=#
"""Variance of a series of additive Bernoulli events

f(p): ∑(p(1-p))
"""
function a_var(p::Array{Float64})
	return reduce(+, map(i_var, p))
end

#=
Variance of multiplicative events
=#
"""Variance of a series of multiplicative Bernoulli events
"""
function m_var(p::Array{Float64})
	return reduce(*, map((x) -> i_var(x) + i_esp(x)*i_esp(x), p)) - reduce(*, map((x) -> i_esp(x)*i_esp(x), p))
end
