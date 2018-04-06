using EcologicalNetwork
using Base.Test

anyerrors = false

my_tests = [
   "types.jl",
   "data.jl",
   "proba_utils.jl",
   "matrix_utils.jl",
   "make_unipartite.jl",
   "degree.jl",
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
   "links/degree.jl",
   "links/specificity.jl"
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
