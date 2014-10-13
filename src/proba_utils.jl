#=

This macro checks that the value passed to it is a float, is at least 0,
and at most 1

It is called internally by the i_var and i_esp function to make sure that
the arguments are actually probabilities

=#
macro checkprob(p)
   quote
      @assert typeof($p) == Float64
      @assert 0.0 <= $p
      @assert $p <= 1.0
   end
end


#=

Esperance of a Bernoulli process (p)

=#
function i_esp(p::Float64)
   @checkprob p
   return p
end


#=

Variance of a Bernoulli process (p(1-p))

=#
function i_var(p::Float64)
   @checkprob p
   return p*(1.0-p)
end


#=

Variance of additive events

=#
function a_var(p::Array{Float64})
   return reduce(+, map(i_var, p))
end

#=

Variance of multiplicative events

=#
function m_var(p::Array{Float64})
   return reduce(*, map((x) -> i_var(x) + i_esp(x)*i_esp(x), p)) - reduce(*, map((x) -> i_esp(x)*i_esp(x), p))
end
