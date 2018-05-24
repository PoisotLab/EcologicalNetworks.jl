import Base.shuffle

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

This function takes sub-matrices of size `size_of_swap` (`(3,3)`; the value of
`size_of_swap` is anything which is accepted by the `sample` function), and
shuffle them around `number_of_swaps` (`1000`) times.

The size and connectance of the network, as well as the performance of the
computer used, should be considered when modifying the values of these
parameters. There is some overhead in the function, as it starts by generating a
lookup table of all potential subgraphs which can be matched. It is better to
use a large number of swaps so that the overhead becomes comparatively less
important.
"""
function shuffle(N::BinaryNetwork; constraint::Symbol=:degree, number_of_swaps::Int64=1000, size_of_swap=(3,3))
    @assert constraint ∈ [:degree, :generality, :vulnerability, :fill]
    @assert number_of_swaps > 0
    @assert minimum(size_of_swap) >= 2

    Y = copy(N)

    # Generate the shufflable matrices
    SeedsTypes = typeof(Y) <: AbstractBipartiteNetwork ? BipartiteNetwork : UnipartiteNetwork

    init_matrices = []
    for i in 1:(prod(size_of_swap)-1)
        A = zeros(Bool, prod(size_of_swap))
        A[1:i] = true
        push!(init_matrices, A)
    end

    matrix_collection = []
    for ni in init_matrices
        for u in unique(collect(permutations(ni)))
            push!(matrix_collection, u)
        end
    end

    # Reshape
    seeds = SeedsTypes.([reshape(x, size_of_swap) for x in matrix_collection])

    # Prepare matrices for compatibility
    same_d_in = zeros(Bool, (length(seeds),length(seeds)))
    same_f = zeros(Bool, (length(seeds),length(seeds)))
    same_d_out = zeros(Bool, (length(seeds),length(seeds)))

    # Fill in compatibility matrices
    for i in eachindex(seeds), j in eachindex(seeds)
        if i != j
            if degree(seeds[i],1) == degree(seeds[j],1)
                same_d_out[i,j] = true
            end
            if degree(seeds[i],2) == degree(seeds[j],2)
                same_d_in[i,j] = true
            end
            if links(seeds[i]) == links(seeds[j])
                same_f[i,j] = true
            end
        end
    end

    # Get the matrix for both degrees
    same_d = same_d_in .& same_d_out

    # Pick the correct matrix based on the constraint
    compatibility_matrix = same_d
    if constraint == :fill
        compatibility_matrix = same_f
    end
    if constraint == :generality
        compatibility_matrix = same_d_out
    end
    if constraint == :vulnerability
        compatibility_matrix = same_d_in
    end

    if sum(compatibility_matrix) == 0
        error("There are no possible swaps of this size")
    end

    # Get the matrices that can be shuffled
    shufflable = [x.A for x in seeds[find(vec(sum(compatibility_matrix,1)).>0)]]

    # Test a matrix
    for swap_number in 1:number_of_swaps
        S = sample(Y, size_of_swap)
        while !(S.A ∈ shufflable)
            S = sample(Y, size_of_swap)
        end

        si = first(filter(i -> seeds[i].A == S.A, 1:length(seeds)))
        replacement = rand(seeds[find(compatibility_matrix[si,:])])
        p1 = indexin(species(S,1), species(Y,1))
        p2 = indexin(species(S,2), species(Y,2))
        Y.A[p1,p2] = replacement.A
    end

    return Y

end
