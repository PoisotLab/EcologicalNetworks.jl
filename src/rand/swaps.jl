import Base.shuffle

function same_degree(x, y)
  return (sum(x,1)==sum(y,1))&(sum(x,2)==sum(y,2))
end

function same_out_degree(x, y)
  return (sum(x,1)==sum(y,1))
end

function same_in_degree(x, y)
  return (sum(x,2)==sum(y,2))
end

function same_fill(x, y)
  return true
end

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
