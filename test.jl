using Revise # To avoid reloading the session while we test things
include("./src/EcologicalNetwork.jl")
using EcologicalNetwork
using StatsBase
using NamedTuples
using Combinatorics
using Base.Test

N = convert(BinaryNetwork, web_of_life("A_HP_001"))

Profile.clear()
@time shuffle(N, number_of_swaps=5)
@profile shuffle(N, number_of_swaps=50)
Juno.profiler()

function interactions2(N::AbstractEcologicalNetwork)
  edges_accumulator = NamedTuple[]
  for s1 in species(N,1)
    for s2 in species(N,2)
      if has_interaction(N, s1, s2)
        fields = [:from, :to]
        values = Any[s1, s2]
        if typeof(N) <: ProbabilisticNetwork
          push!(fields, :probability)
          push!(values, N[s1,s2])
        end
        if typeof(N) <: QuantitativeNetwork
          push!(fields, :strength)
          push!(values, N[s1,s2])
        end
        int_nt = NamedTuples.make_tuple(fields)(tuple(values...)...)
        push!(edges_accumulator, int_nt)
      end
    end
  end
  return unique(edges_accumulator)
end

Profile.clear()
@profile [interactions2(N) for i in 1:1000]
Juno.profiler()
