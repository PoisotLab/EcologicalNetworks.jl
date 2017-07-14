"""
**LP-BRIM**

~~~
function lpbrim(B::BipartiteNetwork, L::Array{Int64, 1})
~~~

Optimizes modularity using LP-BRIM -- this method will first generate a starting
partition using label propagation, then use this as a the starting point in
BRIM. This is expected to give good results especially in large networks, and
can be an alternative to the use of adaptive BRIM.

Supposedly, this approach gives better results when used with each species being
its own module at the beginning.
"""
function lpbrim(B::BipartiteNetwork, L::Array{Int64, 1})
  @assert length(L) == richness(B)
  lp = label_propagation(B, L)
  br = brim(lp)
  return br
end

"""
**LP-BRIM**

~~~
lpbrim(P::Partition)
~~~

LP-BRIM on a partition.
"""
function lpbrim(P::Partition)
  return lpbrim(P.N, P.L)
end
