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
                                  "Core functions" => "interface/highlevel.md"
                                 ],
                  "Network measures" => [
                                         "Links" => "properties/links.md",
                                         "Modularity" => "properties/modularity.md",
                                         "Nestedness" => "properties/nestedness.md",
                                         "Motifs" => "properties/motifs.md",
                                         "Centrality and paths" => "properties/paths.md",
                                         "Food webs" => "properties/foodwebs.md",
                                         "Overlap and similarity" => "properties/overlap.md",
                                         "Beta-diversity" => "properties/betadiversity.md",
                                         "Resilience" => "properties/resilience.md",
                                         "Information theory" => "properties/information.md"
                                        ],
                  "Random networks" => [
                                        "Null models" => "random/null.md",
                                        "Structural models" => "random/structure.md"
                                       ]
                 ]
        )

deploydocs(
           deps   = Deps.pip("pygments", "python-markdown-math"),
           repo   = "github.com/PoisotLab/EcologicalNetworks.jl.git",
           devbranch = "master",
           push_preview = true
          )
