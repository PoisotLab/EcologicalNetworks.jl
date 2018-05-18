import Base.shuffle

function same_degree(x, y)
  return (sum(x,1)==sum(y,1))&(sum(x,2)==sum(y,2))
end

function same_out_degree(x, y)
  return (sum(x,2)==sum(y,2))
end

function same_in_degree(x, y)
  return (sum(x,1)==sum(y,1))
end

function same_fill(x, y)
  return true
end

"""
    shuffle(N::BinaryNetwork; constraint::Symbol=:degree, number_of_swaps::Int64=1000, size_of_swap=(3,3), number_of_candidates::Int64=100)

Returns a new network with its interactions shuffled under a given constraint.
The possible constraints are:

- `:degree`, which keeps the degree distribution intact
- `:generality`, which keeps the out-degree distribution intact
- `:vulnerability`, which keeps the in-degree distribution intact
- `:fill`, which moves interactions around freely

Note that this function will conserve the degree (when appropriate under the
selected constraint) *of every species*.

This function takes sub-matrices of size `size_of_swap` (the value of
`size_of_swap` is anything which is accepted by thee `sample` function), and
shuffle them around `number_of_swaps` time. At every step, there are
`number_of_candidates` shuffled matrices generated, and the first that matches
the constraints is used.

The size and connectance of the network, as well as the performance of the
computer used, should be considered when modifying the values of these
parameters.
"""
function shuffle(N::BinaryNetwork; constraint::Symbol=:degree, number_of_swaps::Int64=1000, size_of_swap=(3,3), number_of_candidates::Int64=100)
    @assert constraint ∈ [:degree, :generality, :vulnerability, :fill]
    @assert number_of_swaps > 0
    @assert minimum(size_of_swap) >= 2
    @assert number_of_candidates > 0

    Y = copy(N)

    validity = Dict([:degree => same_degree, :vulnerability => same_in_degree, :generality => same_out_degree, :fill => same_fill])[constraint]

    for swap_number in 1:number_of_swaps

        seed = sample(Y, size_of_swap)
        while links(seed) == 0
            seed = sample(Y, size_of_swap)
        end

        attempts = [reshape(shuffle(vec(seed.A)), size(seed)) for i in 1:number_of_candidates]
        kept = filter(attempt -> validity(attempt, seed.A), attempts)
        while length(kept) == 0
            attempts = [reshape(shuffle(vec(seed.A)), size(seed)) for i in 1:number_of_candidates]
            kept = filter(attempt -> validity(attempt, seed.A), attempts)
        end

        shuffled_submatrix = first(kept)

        p1 = indexin(species(seed,1), species(N,1))
        p2 = indexin(species(seed,2), species(N,2))

        Y.A[p1,p2] = shuffled_submatrix

    end

    return Y
end
