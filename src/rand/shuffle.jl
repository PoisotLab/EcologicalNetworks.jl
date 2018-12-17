import Random.shuffle
import Random.shuffle!

function swap_degree!(Y::BinaryNetwork)
   iy = interactions(Y)
   i1, i2 = sample(iy, 2, replace=false)
   n1, n2 = (from=i1.from, to=i2.to), (from=i2.from, to=i1.to)

   while (n2 ∈ iy)|(n1 ∈ iy)
      i1, i2 = sample(iy, 2, replace=false)
      n1, n2 = (from=i1.from, to=i2.to), (from=i2.from, to=i1.to)
   end

   for old_i in [i1, i2, n1, n2]
      i = something(findfirst(isequal(old_i.from), species(Y; dims=1)), 0)
      j = something(findfirst(isequal(old_i.to), species(Y; dims=2)), 0)
      Y.A[i,j] = !Y.A[i,j]
   end
end

function swap_fill!(Y::BinaryNetwork)
   iy = interactions(Y)
   i1 = sample(iy)
   n1 = (from=sample(species(Y; dims=1)), to=sample(species(Y; dims=2)))

   while (n1 ∈ iy)
      n1 = (from=sample(species(Y; dims=1)), to=sample(species(Y; dims=2)))
   end

   for old_i in [i1, n1]
      i = something(findfirst(isequal(old_i.from), species(Y; dims=1)), 0)
      j = something(findfirst(isequal(old_i.to), species(Y; dims=2)), 0)
      Y.A[i,j] = !Y.A[i,j]
   end
end

function swap_vulnerability!(Y::BinaryNetwork)
   iy = interactions(Y)
   i1 = sample(iy)
   n1 = (from=sample(species(Y; dims=1)), to=i1.to)

   while (n1 ∈ iy)
      n1 = (from=sample(species(Y; dims=1)), to=i1.to)
   end

   for old_i in [i1, n1]
      i = something(findfirst(isequal(old_i.from), species(Y; dims=1)), 0)
      j = something(findfirst(isequal(old_i.to), species(Y; dims=2)), 0)
      Y.A[i,j] = !Y.A[i,j]
   end
end

function swap_generality!(Y::BinaryNetwork)
   iy = interactions(Y)
   i1 = sample(iy)
   n1 = (from=i1.from, to=sample(species(Y; dims=2)))

   while (n1 ∈ iy)
      n1 = (from=i1.from, to=sample(species(Y; dims=2)))
   end

   for old_i in [i1, n1]
      i = something(findfirst(isequal(old_i.from), species(Y; dims=1)), 0)
      j = something(findfirst(isequal(old_i.to), species(Y; dims=2)), 0)
      Y.A[i,j] = !Y.A[i,j]
   end
end


"""
    shuffle(N::BinaryNetwork; constraint::Symbol=:degree)

Return a shuffled copy of the network (the original network is not modified).
See `shuffle!` for a documentation of the keyword arguments.
"""
function shuffle(N::BinaryNetwork; constraint::Symbol=:degree)
   Y = copy(N)
   shuffle!(Y; constraint=constraint)
   return Y
end

"""
    shuffle!(N::BinaryNetwork; constraint::Symbol=:degree)

Shuffles interactions inside a network (the network is *modified*), under the
following `constraint`:

- :degree, which keeps the degree distribution intact
- :generality, which keeps the out-degree distribution intact
- :vulnerability, which keeps the in-degree distribution intact
- :fill, which moves interactions around freely

The function will take two interactions, and swap the species establishing them.
By repeating the process a large enough number of times, the resulting network
should be relatively random. Note that this function will conserve the degree
(when appropriate under the selected constraint) of *every* species. Calling the
function will perform **a single** shuffle. If you want to repeat the shuffling
a large enough number of times, you can use something like:

    [shuffle!(n) for i in 1:10_000]

If the keyword arguments are invalid, the function will throw an
`ArgumentError`.
"""
function shuffle!(N::BinaryNetwork; constraint::Symbol=:degree)
   constraint ∈ [:degree, :generality, :vulnerability, :fill] || throw(ArgumentError("The constraint argument you specificied ($(constraint)) is invalid -- see ?shuffle! for a list."))

   f = EcologicalNetworks.swap_degree!
   constraint == :generality && (f = EcologicalNetworks.swap_generality!)
   constraint == :vulnerability && (f = EcologicalNetworks.swap_vulnerability!)
   constraint == :fill && (f = EcologicalNetworks.swap_fill!)

   f(N)
end

function quanti_shuffle_valid(a, i1, i2)
    u1 = length(unique(i1)) == 2
    u2 = length(unique(i2)) == 2
    mi = minimum(a[i1,i2]) != zero(eltype(a))
    return u1 & u2 & mi
end

"""
TODO
"""
function shuffle!(N::BipartiteQuantitativeNetwork{Int64,K}; constraint::Symbol=:degree, lims=(0, Inf)) where {K <: AllowedSpeciesTypes}
    constraint ∈ [:degree, :generality, :vulnerability, :fill] || throw(ArgumentError("The constraint argument you specificied ($(constraint)) is invalid -- see ?shuffle! for a list."))
    first(lims) < last(lims) || throw(ArgumentError("The interval you used for limits, $(lims), is invalid"))
    all(first(lims) .<= N.A .<= last(lims)) || throw(ArgumentError("The interval you used for limits, $(lims), is smaller than the range of network values"))

    # List of compatible swap schemes under different constraints
    same_row = [[-1 1; -1 1], [-1 1; 0 0], [-1 1; 1 -1], [0 0; -1 1], [0 0; 1 -1], [1 -1; -1 1], [1 -1; 0 0], [1 -1; 1 -1],]
    same_col = [[-1 -1; 1 1], [-1 0; 1 0], [-1 1; 1 -1], [0 -1; 0 1], [0 1; 0 -1], [1 -1; -1 1], [1 0; -1 0], [1 1; -1 -1],]
    same_all = filter(x -> x ∈ same_row, same_col)
    same_lnk = unique(vcat(same_row, same_col))

    # Pick the correcty matrix series
    m = same_lnk
    constraint == :degree && (m = same_all)
    constraint == :vulnerability && (m = same_col)
    constraint == :generality && (m = same_row)

    permuted = false
    while !permuted
        s1 = rand(1:richness(N; dims=1), 2)
        s2 = rand(1:richness(N; dims=2), 2)
        while !quanti_shuffle_valid(N.A, s1, s2)
            s1 = rand(1:richness(N; dims=1), 2)
            s2 = rand(1:richness(N; dims=2), 2)
        end
        st1 = filter(a -> all(first(lims).<=a.<=last(lims)), [N[s1,s2] .+ x for x in m])
        st2 = filter(a -> all((N[s1,s2].!=0).==(a.!=0)), st1)
        if length(st2) > 0
            permuted = true
            k = rand(st2)
            for i in 1:2, j in 1:2
                N[s1[i],s2[j]] = k[i,j]
            end
        end
    end
end

"""
TODO
"""
function shuffle!(N::BipartiteQuantitativeNetwork{Float64,K}; ε::Float64=1e-2, constraint::Symbol=:degree, lims=(0.0, Inf)) where {K <: AllowedSpeciesTypes}
    constraint ∈ [:degree, :generality, :vulnerability, :fill] || throw(ArgumentError("The constraint argument you specificied ($(constraint)) is invalid -- see ?shuffle! for a list."))
    first(lims) < last(lims) || throw(ArgumentError("The interval you used for limits, $(lims), is invalid"))
    all(first(lims) .<= N.A .<= last(lims)) || throw(ArgumentError("The interval you used for limits, $(lims), is smaller than the range of network values"))

    # List of compatible swap schemes under different constraints
    same_row = [[-1 1; -1 1], [-1 1; 0 0], [-1 1; 1 -1], [0 0; -1 1], [0 0; 1 -1], [1 -1; -1 1], [1 -1; 0 0], [1 -1; 1 -1],]
    same_col = [[-1 -1; 1 1], [-1 0; 1 0], [-1 1; 1 -1], [0 -1; 0 1], [0 1; 0 -1], [1 -1; -1 1], [1 0; -1 0], [1 1; -1 -1],]
    same_all = filter(x -> x ∈ same_row, same_col)
    same_lnk = unique(vcat(same_row, same_col))

    # Pick the correcty matrix series
    m = same_lnk
    constraint == :degree && (m = same_all)
    constraint == :vulnerability && (m = same_col)
    constraint == :generality && (m = same_row)
    m = m.*ε

    permuted = false
    while !permuted
        s1 = rand(1:richness(N; dims=1), 2)
        s2 = rand(1:richness(N; dims=2), 2)
        while !quanti_shuffle_valid(N.A, s1, s2)
            s1 = rand(1:richness(N; dims=1), 2)
            s2 = rand(1:richness(N; dims=2), 2)
        end
        st1 = filter(a -> all(first(lims).<=a.<=last(lims)), [N[s1,s2] .+ x for x in m])
        st2 = filter(a -> all((N[s1,s2].!=0).==(a.!=0)), st1)
        if length(st2) > 0
            permuted = true
            k = rand(st2)
            for i in 1:2, j in 1:2
                N[s1[i],s2[j]] = k[i,j]
            end
        end
    end
end

"""
TODO
"""
function shuffle!(N::UnipartiteQuantitativeNetwork{Int64,K}; constraint::Symbol=:degree, lims=(0, Inf)) where {K <: AllowedSpeciesTypes}
    constraint ∈ [:degree, :generality, :vulnerability, :fill] || throw(ArgumentError("The constraint argument you specificied ($(constraint)) is invalid -- see ?shuffle! for a list."))
    first(lims) < last(lims) || throw(ArgumentError("The interval you used for limits, $(lims), is invalid"))
    all(first(lims) .<= N.A .<= last(lims)) || throw(ArgumentError("The interval you used for limits, $(lims), is smaller than the range of network values"))

    # List of compatible swap schemes under different constraints
    same_row = [[-1 1; -1 1], [-1 1; 0 0], [-1 1; 1 -1], [0 0; -1 1], [0 0; 1 -1], [1 -1; -1 1], [1 -1; 0 0], [1 -1; 1 -1],]
    same_col = [[-1 -1; 1 1], [-1 0; 1 0], [-1 1; 1 -1], [0 -1; 0 1], [0 1; 0 -1], [1 -1; -1 1], [1 0; -1 0], [1 1; -1 -1],]
    same_all = filter(x -> x ∈ same_row, same_col)
    same_lnk = unique(vcat(same_row, same_col))

    # Pick the correcty matrix series
    m = same_lnk
    constraint == :degree && (m = same_all)
    constraint == :vulnerability && (m = same_col)
    constraint == :generality && (m = same_row)

    permuted = false
    while !permuted
        s1 = rand(1:richness(N; dims=1), 2)
        while !quanti_shuffle_valid(N.A, s1, s1)
            s1 = rand(1:richness(N; dims=1), 2)
        end
        st1 = filter(a -> all(first(lims).<=a.<=last(lims)), [N[s1,s1] .+ x for x in m])
        st2 = filter(a -> all((N[s1,s1].!=0).==(a.!=0)), st1)
        if length(st2) > 0
            permuted = true
            k = rand(st2)
            for i in 1:2, j in 1:2
                N[s1[i],s1[j]] = k[i,j]
            end
        end
    end
end

"""
TODO
"""
function shuffle!(N::UnipartiteQuantitativeNetwork{Float64,K}; ε::Float64=1e-2, constraint::Symbol=:degree, lims=(0.0, Inf)) where {K <: AllowedSpeciesTypes}
    constraint ∈ [:degree, :generality, :vulnerability, :fill] || throw(ArgumentError("The constraint argument you specificied ($(constraint)) is invalid -- see ?shuffle! for a list."))
    first(lims) < last(lims) || throw(ArgumentError("The interval you used for limits, $(lims), is invalid"))
    all(first(lims) .<= N.A .<= last(lims)) || throw(ArgumentError("The interval you used for limits, $(lims), is smaller than the range of network values"))

    # List of compatible swap schemes under different constraints
    same_row = [[-1 1; -1 1], [-1 1; 0 0], [-1 1; 1 -1], [0 0; -1 1], [0 0; 1 -1], [1 -1; -1 1], [1 -1; 0 0], [1 -1; 1 -1],]
    same_col = [[-1 -1; 1 1], [-1 0; 1 0], [-1 1; 1 -1], [0 -1; 0 1], [0 1; 0 -1], [1 -1; -1 1], [1 0; -1 0], [1 1; -1 -1],]
    same_all = filter(x -> x ∈ same_row, same_col)
    same_lnk = unique(vcat(same_row, same_col))

    # Pick the correcty matrix series
    m = same_lnk
    constraint == :degree && (m = same_all)
    constraint == :vulnerability && (m = same_col)
    constraint == :generality && (m = same_row)
    m = m.*ε

    permuted = false
    while !permuted
        s1 = rand(1:richness(N; dims=1), 2)
        while !quanti_shuffle_valid(N.A, s1, s1)
            s1 = rand(1:richness(N; dims=1), 2)
        end
        st1 = filter(a -> all(first(lims).<=a.<=last(lims)), [N[s1,s1] .+ x for x in m])
        st2 = filter(a -> all((N[s1,s1].!=0).==(a.!=0)), st1)
        if length(st2) > 0
            permuted = true
            k = rand(st2)
            for i in 1:2, j in 1:2
                N[s1[i],s1[j]] = k[i,j]
            end
        end
    end
end

"""
    shuffle(N::T; kwargs...) where {T <: QuantitativeNetwork}

Shuffle a quantitative network -- see shuffle!
"""
function shuffle(N::T; kwargs...) where {T <: QuantitativeNetwork}
    Y = copy(N)
    @info kwargs
    shuffle!(Y; kwargs...)
    return Y
end
