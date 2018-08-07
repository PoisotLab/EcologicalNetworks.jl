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
    shuffle(N::BinaryNetwork; constraint::Symbol=:degree, number_of_swaps::Int64=1000)

Return a shuffled copy of the network. See `shuffle!` for a documentation of the keyword arguments.
"""
function shuffle(N::BinaryNetwork; constraint::Symbol=:degree, number_of_swaps::Int64=1000)
   Y = copy(N)
   shuffle!(Y; constraint=constraint, number_of_swaps=number_of_swaps)
   return Y
end

"""
    shuffle!(N::BinaryNetwork; constraint::Symbol=:degree, number_of_swaps::Int64=1000)

Shuffles interactions inside a network (the network is *modified*), under the
following `constraint`:

- :degree, which keeps the degree distribution intact
- :generality, which keeps the out-degree distribution intact
- :vulnerability, which keeps the in-degree distribution intact
- :fill, which moves interactions around freely

Note that this function will conserve the degree (when appropriate under the
selected constraint) of *every* species. This function will take number_of_swaps
(1000) interactions, swap them, and return a copy of the network.

If the keyword arguments are invalid, the function will throw an
`ArgumentError`.
"""
function shuffle!(N::BinaryNetwork; constraint::Symbol=:degree, number_of_swaps::Int64=1000)
   constraint ∈ [:degree, :generality, :vulnerability, :fill] || throw(ArgumentError("The constraint argument you specificied ($(constraint)) is invalid -- see ?shuffle! for a list."))
   number_of_swaps > 0 || throw(ArgumentError("The number of swaps *must* be positive, you used $(number_of_swaps)"))

   f = EcologicalNetworks.swap_degree!
   constraint == :generality && (f = EcologicalNetworks.swap_generality!)
   constraint == :vulnerability && (f = EcologicalNetworks.swap_vulnerability!)
   constraint == :fill && (f = EcologicalNetworks.swap_fill!)

   for swap_number in 1:number_of_swaps
      f(N)
   end

end
