using EcologicalNetwork
using Base.Test

anyerrors = false

my_tests = [
   "matrix_utils.jl",
   "free_species.jl",
   "connectance.jl",
   "paths.jl",
   "nestedness.jl",
   "nullmodels.jl",
   "nullmodelswrapper.jl",
   "swaps.jl",
   "foodwebs.jl",
   "centrality.jl",
   "tests.jl",
   "motifs.jl",
   "betadiversity.jl",
   "modularity.jl",
   "draw.jl"
  ]

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
   "rand/swaps.jl"
]

for my_test in my_tests
  try
    include(my_test)
    println(">> \033[1m\033[32m++\033[0m $(my_test)")
  catch e
    anyerrors = true
    println(">> \033[1m\033[31m!!\033[0m $(my_test)")
    showerror(STDOUT, e, backtrace())
    println()
  end
end

if anyerrors
  throw("Tests failed")
end
