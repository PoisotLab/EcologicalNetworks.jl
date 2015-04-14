#=
Type I
=#
@doc """
Given a matrix `A`, `null1(A)` returns a matrix with the same dimensions, where
every interaction happens with a probability equal to the connectance of `A`.
""" ->
function null1(A::Array{Float64, 2})
  return ones(A) .* connectance(A)
end

#=
Type III out
=#
@doc """
Given a matrix `A`, `null3out(A)` returns a matrix with the same dimensions,
where every interaction happens with a probability equal to the out-degree
(number of successors) of each species, divided by the total number of possible
successors.
""" ->
function null3out(A::Array{Float64, 2})
  p_rows = degree_out(A) ./ size(A)[2]
  return hcat(map((x) -> p_rows, [1:size(A)[2];])...)
end

#=
Type III in
=#
@doc """
Given a matrix `A`, `null3in(A)` returns a matrix with the same dimensions,
where every interaction happens with a probability equal to the in-degree
(number of predecessors) of each species, divided by the total number of
possible predecessors.
""" ->
function null3in(A::Array{Float64, 2})
  return null3out(A')' # I don't work hard, so I work smart
end

#=
Type II
=#
@doc """
Given a matrix `A`, `null2(A)` returns a matrix with the same dimensions, where
every interaction happens with a probability equal to the degree of each
species.
""" ->
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
@doc """ This function is a wrapper to generate replicated binary matrices from
a template probability matrix `A`.

If you use julia on more than one CPU, *i.e.* if you started it with `julia -p
k` where `k` is more than 1, this function will distribute each trial to one
worker. Which means that it's fast.

Note that you will get a warning if there are less networks created than have
been requested. Not also that this function generates networks, but do not check
that their distribution is matching what you expect. Simulated annealing
routines will be part of a later release.

**Keyword arguments**

- `n` (def. 1000), number of replicates to generate
- `max` (def. 10000), number of trials to make

""" ->
function nullmodel(A::Array{Float64, 2}; n=1000, max=10000)
  if max < n
    max = n
    info("Less maximal trials than requested sample size; adjusted.")
  end
  # Number of cores
  np = nprocs()
  # Hold the results
  b = Array{Float64, 2}[]
  i = 1
  nextidx() = (idx=i; i+=1; idx)
  # Run simulations until there are enough networks
  @sync begin
    for p=1:np
      if (p != myid() || np == 1) && (length(b) < n)
        @async begin
          while true
            idx = nextidx()
            if idx > n
              break
            end
            B = remotecall_fetch(p, make_bernoulli, A)
            if free_species(B) == 0
              push!(b, B)
            end
          end
        end
      end
    end
  end
  if length(b) < n
    warn("Less samples than requested were found")
  end
  return b
end
