using Documenter
using EcologicalNetwork

push!(LOAD_PATH, "../src/")

makedocs(
         modules = [EcologicalNetwork]
        )
