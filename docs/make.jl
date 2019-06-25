using Pkg

push!(LOAD_PATH,"../src/")

Pkg.activate(".")

using Documenter
using EcologicalNetworks

makedocs(
    sitename = "EcologicalNetworks",
    authors = "Timothée Poisot",
    modules = [EcologicalNetworks],
    pages = [
        "Index" => "index.md",
        "Interface" => [
            "Types" => "interface/types.md",
            "Conversions" => "interface/conversions.md",
            "Core functions" => "interface/highlevel.md"
        ],
        "Network measures" => [
            "Links" => "properties/links.md",
            "Modularity" => "properties/modularity.md",
            "Nestedness" => "properties/nestedness.md",
            "Motifs" => "properties/motifs.md",
            "Centrality and paths" => "properties/paths.md",
            "Overlap and similarity" => "properties/overlap.md",
            "Null models" => "properties/nullmodels.md",
            "Beta-diversity" => "properties/betadiversity.md",
            "Resilience" => "properties/resilience.md"
            "Information theory" => "properties/information.md",
        ]
    ]
)

deploydocs(
    deps   = Deps.pip("pygments", "python-markdown-math"),
    repo   = "github.com/PoisotLab/EcologicalNetworks.jl.git",
    devbranch = "develop"
)

