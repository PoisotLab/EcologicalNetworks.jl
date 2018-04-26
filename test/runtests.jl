using EcologicalNetwork
using Base.Test

anyerrors = false

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
   "rand/swaps.jl",
   "rand/null.jl",
   "community/nestedness.jl",
   "community/paths.jl",
   "community/centrality.jl",
   "community/motifs.jl",
   "betadiversity/operations.jl",
   "modularity/utilities.jl",
   "modularity/labelpropagation.jl",
   "modularity/brim.jl",
   "modularity/louvain.jl"
]

test_n = 1
for my_test in shuffle(my_tests)
  try
    include(my_test)
    println("[TEST $(lpad(test_n,2))] \033[1m\033[32mPASS\033[0m $(my_test)")
  catch e
    anyerrors = true
    println("[TEST $(lpad(test_n,2))] \033[1m\033[31mFAIL\033[0m $(my_test)")
    showerror(STDOUT, e, backtrace())
    println()
  end
  test_n += 1
end

if anyerrors
  throw("Tests failed")
end
