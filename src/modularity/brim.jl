"""
**Pick a module at random**

~~~julia
pick_random_module(x::Array{Int64, 1})
~~~

Returns a random module if there are several choices for the best
solution. Used internally by brim.
"""
function pick_random_module(x::Array{Int64, 1})
  if sum(x) > 1
    keep = rand(find(n -> n == 1, x))
    x = map(n -> n==keep ? 1 : 0, 1:length(x))
  end
  return x
end


"""
**Bipartite Recursively Induced Modularity**

~~~
brim(P::Partition)
~~~

Returns the best partition using BRIM, based on a Partition object.
"""
function brim(P::Partition)
  return brim(P.N, P.L)
end

"""
**Bipartite Recursively Induced Modularity**

~~~
brim(N::BipartiteNetwork, L::Array{Int64, 1})
~~~

Returns the best partition using BRIM, based on a network and an initial
set of modules.
"""
function brim(N::BipartiteNetwork, L::Array{Int64, 1})
  @assert length(L) == richness(N)

  old_Q = Q(N, L)
  new_Q = old_Q+0.00001

  m = links(N)

  # R and T matrices
  nL = zeros(L)
  for (i, l) in enumerate(unique(L))
    nL[L.==l] = i
  end
  L = deepcopy(nL)
  c = length(unique(L))
  R = map(Int64, L[1:size(N.A,1)] .== unique(L)')
  T = map(Int64, L[(size(N.A,1)+1):end] .== unique(L)')
  B = N.A .- kron(degree_out(N), degree_in(N)')./m

  while old_Q < new_Q

    t_tilde = B*T
    R = map(Int64, t_tilde .== maximum(t_tilde, 2))
    r_tilde = B'*R
    T = map(Int64, r_tilde .== maximum(r_tilde, 2))
    S = vcat(R, T)
    S = mapslices(pick_random_module, S, 2)
    L = vec(mapslices(x -> find(k -> k==1, x), S, 2))

    old_Q = new_Q
    new_Q = Q(N,L)

  end

  return Partition(N, L, new_Q)

end
