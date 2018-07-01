using Revise # To avoid reloading the session while we test things
include("./src/EcologicalNetwork.jl")
using EcologicalNetwork
using StatsBase
using NamedTuples
using Combinatorics
using Base.Test
using StatPlots

N = UnipartiteNetwork([false true true; true false true; false false false])
fractional_trophic_level(N)

Ns = [UnipartiteNetwork(rand(Bool, (10,10))) for i in 1:100]
N = Ns[1]
@progress for N in Ns
    info("ping")
    fractional_trophic_level(N)
end


A = [0 0 0 0 ; 1 0 0 0; 1 0 0 1; 0 1 1 0]
N = UnipartiteNetwork(A.>0)

function nonzeromean(x)
  if sum(x) == 0
    return 0.0
  end
  return mean(x[x.>0])
end

Y = copy(nodiagonal(N))
producers = keys(filter((sp,de) -> de == 0, degree(Y,1)))
sp = shortest_path(Y)
prod_id = find(sum(sp,2).==0)
tl = Dict(zip(species(Y,1), mean(sp[:,prod_id],2).+1.0))
