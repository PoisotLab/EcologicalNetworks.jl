"""
Given a matrix `A`, `null1(A)` returns a matrix with the same dimensions, where
every interaction happens with a probability equal to the connectance of `A`.
"""
function null1(N::DeterministicNetwork)
    itype = typeof(N) <: Bipartite ? BipartiteProbaNetwork : UnipartiteProbaNetwork
    return itype(ones(N.A) .* connectance(N))
end

"""
Given a matrix `A`, `null3out(A)` returns a matrix with the same dimensions,
where every interaction happens with a probability equal to the out-degree
(number of successors) of each species, divided by the total number of possible
successors.
"""
function null3out(N::DeterministicNetwork)
    itype = typeof(N) <: Bipartite ? BipartiteProbaNetwork : UnipartiteProbaNetwork
    p_rows = degree_out(N) ./ size(N)[2]
    return itype(hcat(map((x) -> p_rows, [1:size(N)[2];])...))
end

"""
Given a matrix `A`, `null3in(A)` returns a matrix with the same dimensions,
where every interaction happens with a probability equal to the in-degree
(number of predecessors) of each species, divided by the total number of
possible predecessors.
"""
function null3in(N::DeterministicNetwork)
    return null3out(N')' # I don't work hard, so I work smart
end

"""
Given a matrix `A`, `null2(A)` returns a matrix with the same dimensions, where
every interaction happens with a probability equal to the degree of each
species.
"""
function null2(N::DeterministicNetwork)
    itype = typeof(N) <: Bipartite ? BipartiteProbaNetwork : UnipartiteProbaNetwork
    # NOTE This is of course not ideal, in that I'd rather have additions for
    # network types, but that will do for now
    return itype((null3in(N).A .+ null3out(N).A)./2.0)
end

"""
This function is a wrapper to generate replicated binary matrices from
a template probability matrix `A`.

If you use julia on more than one CPU, *i.e.* if you started it with `julia -p
k` where `k` is more than 1, this function will distribute each trial to one
worker. Which means that it's fast.

**Keyword arguments**

- `n` (def. 1000), number of replicates to generate
- `max` (def. 10000), number of trials to make

"""
function nullmodel(N::ProbabilisticNetwork; n=1000, max=10000)
    if max < n
        max = n
    end
    # Number of cores
    np = nprocs()
    # Hold the results
    itype = typeof(N) <: Unipartite ? UnipartiteNetwork : BipartiteNetwork
    b = Array{itype}[]
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
                    B = remotecall_fetch(make_bernoulli, p, N)
                    if free_species(B) == 0
                        push!(b, B)
                    end
                end
            end
            end
        end
    end
    return b
end
