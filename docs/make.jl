push!(LOAD_PATH, "../src/")

using Documenter
using DocumenterMarkdown
using SpeciesInteractionNetworks

makedocs(;
    sitename = "SpeciesInteractionNetworks",
    authors = "Timothée Poisot",
    modules = [SpeciesInteractionNetworks],
    format = Markdown(),
)

deploydocs(;
    deps = Deps.pip("mkdocs", "pygments", "python-markdown-math", "mkdocs-material"),
    repo = "github.com/PoisotLab/EcologicalNetworks.jl.git",
    devbranch = "main",
    make = () -> run(`mkdocs build`),
    target = "site",
    push_preview = true,
)
