const SWAP_MAXITER = 100

@enum PermutationStrategy begin
    Degree = 1
    Generality = 2
    Vulnerability = 3
    Connectance = 4
end

function swap!(N::SpeciesInteractionNetwork{<:Partiteness, <:Binary}; constraint::PermutationStrategy=Degree)
    if length(N) < 2 
        throw(ArgumentError("Impossible to swap a network with fewer than two interactions"))
    end
    (constraint == Degree) && swap_degree!(N)
    return N
end

function swap_degree!(N::SpeciesInteractionNetwork{<:Partiteness, <:Binary})
    intpool = interactions(N)
    intpair = StatsBase.sample(intpool, 2, replace=false)
    iters = 0
    valid = iszero(N[intpair[1][1], intpair[2][2]]) & iszero(N[intpair[2][1], intpair[1][2]])
    while (!valid)||(iter < SWAP_MAXITER)
        intpair = StatsBase.sample(intpool, 2, replace=false)
        valid = iszero(N[intpair[1][1], intpair[2][2]]) & iszero(N[intpair[2][1], intpair[1][2]])
        iters += 1
    end
    if iter < SWAP_MAXITER
        N[intpair[1][1], intpair[1][2]] = false
        N[intpair[2][1], intpair[2][2]] = false
        N[intpair[1][1], intpair[2][2]] = true
        N[intpair[2][1], intpair[1][2]] = true
    end
    return N
end