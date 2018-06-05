import Base.shuffle

function swap_degree!(Y::BinaryNetwork)
    iy = interactions(Y)
    i1, i2 = sample(iy, 2, replace=false)
    n1, n2 = @NT(from=i1.from, to=i2.to), @NT(from=i2.from, to=i1.to)

    while (n2 ∈ iy)|(n1 ∈ iy)
        i1, i2 = sample(iy, 2, replace=false)
        n1, n2 = @NT(from=i1.from, to=i2.to), @NT(from=i2.from, to=i1.to)
    end

    for old_i in [i1, i2, n1, n2]
        i = findfirst(species(Y,1), old_i.from)
        j = findfirst(species(Y,2), old_i.to)
        Y.A[i,j] = !Y.A[i,j]
    end
end

function swap_fill!(Y::BinaryNetwork)
    iy = interactions(Y)
    i1 = sample(iy)
    n1 = @NT(from=sample(species(Y,1)), to=sample(species(Y,2)))

    while (n1 ∈ iy)
        n1 = @NT(from=sample(species(Y,1)), to=sample(species(Y,2)))
    end

    for old_i in [i1, n1]
        i = findfirst(species(Y,1), old_i.from)
        j = findfirst(species(Y,2), old_i.to)
        Y.A[i,j] = !Y.A[i,j]
    end
end

function swap_vulnerability!(Y::BinaryNetwork)
    iy = interactions(Y)
    i1 = sample(iy)
    n1 = @NT(from=sample(species(Y,1)), to=i1.to)

    while (n1 ∈ iy)
        n1 = @NT(from=sample(species(Y,1)), to=i1.to)
    end

    for old_i in [i1, n1]
        i = findfirst(species(Y,1), old_i.from)
        j = findfirst(species(Y,2), old_i.to)
        Y.A[i,j] = !Y.A[i,j]
    end
end

function swap_generality!(Y::BinaryNetwork)
    iy = interactions(Y)
    i1 = sample(iy)
    n1 = @NT(from=i1.from, to=sample(species(Y,2)))

    while (n1 ∈ iy)
        n1 = @NT(from=i1.from, to=sample(species(Y,2)))
    end

    for old_i in [i1, n1]
        i = findfirst(species(Y,1), old_i.from)
        j = findfirst(species(Y,2), old_i.to)
        Y.A[i,j] = !Y.A[i,j]
    end
end


"""
    shuffle(N::BinaryNetwork; constraint::Symbol=:degree, number_of_swaps::Int64=1000)

Returns a new network with its interactions shuffled under a given constraint.
The possible constraints are:

- `:degree`, which keeps the degree distribution intact
- `:generality`, which keeps the out-degree distribution intact
- `:vulnerability`, which keeps the in-degree distribution intact
- `:fill`, which moves interactions around freely

Note that this function will conserve the degree (when appropriate under the
selected constraint) *of every species*.

This function will take `number_of_swaps` (`1000`) interactions, swap them, and
return a copy of the network.
"""
function shuffle(N::BinaryNetwork; constraint::Symbol=:degree, number_of_swaps::Int64=1000, size_of_swap=(3,3))
    @assert constraint ∈ [:degree, :generality, :vulnerability, :fill]
    @assert number_of_swaps > 0

    Y = copy(N)

    f = EcologicalNetwork.swap_degree!
    if constraint == :generality
        f = EcologicalNetwork.swap_generality!
    end
    if constraint == :vulnerability
        f = EcologicalNetwork.swap_vulnerability!
    end
    if constraint == :fill
        f = EcologicalNetwork.swap_fill!
    end

    # Test a matrix
    for swap_number in 1:number_of_swaps
        f(Y)
    end

    return Y

end
