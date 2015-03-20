#=
Type I
=#
function null1(A::Array{Float64, 2})
   return ones(A) .* connectance(A)
end

#=
Type III out
=#
function null3out(A::Array{Float64, 2})
   p_rows = degree_out(A) ./ size(A)[2]
   return hcat(map((x) -> p_rows, [1:size(A)[2];])...)
end

#=
Type III in
=#
function null3in(A::Array{Float64, 2})
   return null3out(A')' # I don't work hard, so I work smart
end

#=
Type II
=#
function null2(A::Array{Float64, 2})
   return (null3in(A) .+ null3out(A))./2.0
end

#=
Wrapper for null models

Takes a proba matrix, and generates 0/1 networks until there are n done, or max
have been tried.

This function will try to run in parallel, because otherwise it takes forever to
go through all of the potential networks.

=#
function nullmodel(A::Array{Float64, 2}; n=1000, max=10000)
  if max < n
    max = n
    info("Less maximal trials than requested sample size; adjusted.")
  end
  b = Array{Float64, 2}[]
  trials = pmap((x) -> make_bernoulli(A), vec(1:max))
  filter!((n) -> free_species(n) == 0, trials)
  if length(trials) < n
    b = trials
    warn("Less samples than requested were found")
  else
    for i in 1:n
      push!(b, pop!(trials))
      if length(b) == n
        break
      end
    end
  end
  return b
end
