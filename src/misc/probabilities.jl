"""
Quite crude way of checking that a number is a probability

The two steps are

1. The number should be of the `Float64` type
2. The number should belong to [0.0,1.0]
"""
function _value_is_a_probability(p::T) where {T<:AbstractFloat}
	(0.0 <= p <= 1.0) || throw(ArgumentError("The value p=$(p) is not a probability"))
	return nothing
end


"""
Expected value of a single Bernoulli event

Simply f(p): p
"""
function _single_bernoulli_expectation(p::Float64)
    _value_is_a_probability(p)
	return p
end

"""
Variance of a single Bernoulli event

f(p): p(1-p)
"""
function _single_bernoulli_variance(p::Float64)
    _value_is_a_probability(p)
	return p*(1.0-p)
end


"""
Variance of a series of additive Bernoulli events

f(p): ∑(p(1-p))
"""
function _additive_bernoulli_variance(p::Array{Float64})
	return sum(_single_bernoulli_variance.(p))
end

"""
Variance of a series of multiplicative Bernoulli events
"""
function _multiplicative_bernoulli_variance(p::Array{Float64})
	# LOLWUT
	return reduce(*, map((x) -> _single_bernoulli_variance(x) + _single_bernoulli_expectation(x)*_single_bernoulli_expectation(x), p)) - reduce(*, map((x) -> _single_bernoulli_expectation(x)*_single_bernoulli_expectation(x), p))
end
