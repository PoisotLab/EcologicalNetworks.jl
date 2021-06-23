using EcologicalNetworks
using Test
using LinearAlgebra

my_tests = [
    "types/declaration.jl",
    "types/utilities.jl",
    "types/conversions.jl",
    "data.jl",
    "links/degree.jl",
    "links/specificity.jl",
    "links/connectance.jl",
    "links/degenerate.jl",
    "rand/draws.jl",
    "rand/shuffle.jl",
    "rand/null.jl",
    "rand/sample.jl",
    "rand/cascademodel.jl",
    "rand/nestedhierarchymodel.jl",
    "rand/nichemodel.jl",
    "rand/mpnmodel.jl",
    "community/nestedness.jl",
    "community/paths.jl",
    "community/overlap.jl",
    "community/centrality.jl",
    "community/motifs.jl",
    "community/foodwebs.jl",
    "community/resilience.jl",
    "community/spectralradius.jl",
    "betadiversity/operations.jl",
    "betadiversity/partitions.jl",
    "modularity/utilities.jl",
    "modularity/starters.jl",
    "modularity/labelpropagation.jl",
    "modularity/brim.jl",
    "modularity/roles.jl",
    "information/entropy.jl",
    "information/otsin.jl"
]
# "mangal.jl",

global test_n
global anyerrors

test_n = 1
anyerrors = false

for my_test in my_tests
  try
    include(my_test)
    println("[TEST $(lpad(test_n,2))] \033[1m\033[32mPASS\033[0m $(my_test)")
  catch e
    global anyerrors = true
    println("[TEST $(lpad(test_n,2))] \033[1m\033[31mFAIL\033[0m $(my_test)")
    showerror(stdout, e, backtrace())
    println()
    throw("TEST FAILED")
  end
  global test_n += 1
end

if anyerrors
  throw("Tests failed")
end
