push!(LOAD_PATH,"../src/")

using Documenter, EcologicalNetwork

makedocs(
    modules = [EcologicalNetwork]
)

deploydocs(
    deps   = Deps.pip("pygments", "mkdocs", "mkdocs-material", "python-markdown-math"),
    repo   = "github.com/PoisotLab/EcologicalNetwork.jl.git",
    julia  = "0.6"
)
