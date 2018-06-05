using Revise # To avoid reloading the session while we test things
include("./src/EcologicalNetwork.jl")
using EcologicalNetwork
using StatsBase
using NamedTuples
using Combinatorics
using Base.Test

N = convert(BinaryNetwork, web_of_life("A_HP_001"))
s = typeof(N)[]
push!(s, copy(N))

for i in 2:200
  push!(s, shuffle(s[i-1]; constraint=:degree, number_of_swaps=1))
end

m_null = BipartiteNetwork([false false; false false])
m_zeta = BipartiteNetwork([true false; true true])
m_bicl = BipartiteNetwork([true true; true true])
m_appa = BipartiteNetwork([false false; true true])
m_dire = BipartiteNetwork([true false; true false])

f(n,m) = length(find_motif(n,m))

o = zeros(Int64, (length(s), 5))
@progress for i in eachindex(s)
  o[i,1] = f(s[i], m_null)
  o[i,2] = f(s[i], m_appa)
  o[i,3] = f(s[i], m_dire)
  o[i,4] = f(s[i], m_zeta)
  o[i,5] = f(s[i], m_bicl)
end

O = copy(o)
O = convert.(Float64, O)
for i in 1:size(O,2)
  println(i)
  O[:,i] = (O[:,i].-O[1,i])./(O[1,i])
end

heatmap(O', c=:PRGn, aspectratio=10, clim=(-0.15,0.15))
