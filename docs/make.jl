using Pkg
using Documenter

push!(LOAD_PATH,"../src/")

Pkg.activate(".")
using EcologicalNetworks

makedocs(
    modules = [EcologicalNetworks]
)

deploydocs(
    deps   = Deps.pip("pygments", "mkdocs", "mkdocs-material", "python-markdown-math"),
    repo   = "github.com/PoisotLab/EcologicalNetworks.jl.git",
    julia  = "0.7"
)
