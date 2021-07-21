push!(LOAD_PATH,"../src/")

using Documenter
using EcologicalNetworks
using Random

makedocs(
    sitename = "EcologicalNetworks",
    authors = "Timothée Poisot",
    modules = [EcologicalNetworks],
    pages = [
        "Index" => "index.md",
        "Interface" => [
            "Types" => "interface/types.md",
            "Conversions" => "interface/conversions.md",
            "Core functions" => "interface/highlevel.md",
            "AbstractArray" => "interface/abstractarray.md",
            "Iterate" => "interface/iterate.md"
        ],
        "Examples" => [
            "Modularity" => "examples/modularity.md",
            "Centrality" => "examples/centrality.md",
            "Integration with Mangal" => "examples/mangal.md",
            "Network beta-diversity" => "examples/beta-diversity.md",
            "Extinctions" => "examples/extinctions.md"
        ],
        "Basic measures" => [
            "Links" => "properties/links.md",
            "Modularity" => "properties/modularity.md",
            "Nestedness" => "properties/nestedness.md",
            "Motifs" => "properties/motifs.md",
            "Centrality and paths" => "properties/paths.md",
            "Overlap and similarity" => "properties/overlap.md"
        ],
        "Advanced information" => [
            "Beta-diversity" => "properties/betadiversity.md",
            "Resilience" => "properties/resilience.md",
            "Information theory" => "properties/information.md"
        ],
        "Generating networks" => [
            "Null models" => "random/null.md",
            "Structural models" => "random/structure.md",
            "Optimal transportation" => "random/otsin.md"
        ]
    ]
)

deploydocs(
deps   = Deps.pip("pygments", "python-markdown-math"),
repo   = "github.com/EcoJulia/EcologicalNetworks.jl.git",
devbranch = "main",
push_preview = true
)
