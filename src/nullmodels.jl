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
  max = max < n ? n : max
  np = nprocs()
  b = Array{Float64, 2}[]
  has_left = true
  has_enough = false
  done = 0
  while !(has_enough) & has_left
    # We do as many trials as there are available cores
    done += np
    trials = pmap((x) -> make_bernoulli(A), 1:np)
    # Next, we check that there are no networks with empty species
    filter!((n) -> free_species(n) == 0, trials)
    # If so, we add them to the queue until the queue is full
    if length(trials) > 0
      if length(b) < n
        push!(b, pop!(trials))
      end
    end
    has_enough = (length(b) == n)
    #has_left = (done < max)
  end
  # while !(has_enough) & has_left
  #   done += 1
  #   trial = make_bernoulli(A)
  #   if free_species(trial) == 0
  #     push!(b, trial)
  #   end
  #   has_enough = (length(b) == n)
  #   has_left = (done < max)
  # end
  return b
end
