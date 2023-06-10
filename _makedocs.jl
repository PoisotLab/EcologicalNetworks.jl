import Pkg
Pkg.activate("docs/")
Pkg.instantiate()
#Pkg.develop("SpeciesInteractionNetworks")
include("docs/make.jl")
cd("docs")
run(`mkdocs build`)
cd("..")