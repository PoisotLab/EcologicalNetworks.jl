push!(LOAD_PATH,"../src/")

using Documenter, EcologicalNetwork

makedocs(
    modules = [EcologicalNetwork]
)
