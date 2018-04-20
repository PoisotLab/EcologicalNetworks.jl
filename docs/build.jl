using Weave

using Plots
using StatPlots
plotly()

include("../src/EcologicalNetwork.jl")

# Manual

case_dir = "test/manual/"
cases = readdir(case_dir)
valid_cases = filter(f -> contains(f, "_source.jl"), cases)


for case in joinpath.(case_dir, valid_cases)
    println(case)
    x = last(split(case, "test/manual/"))
    x = first(split(x, "_source.jl"))
    println(x)
    weave(case, out_path="docs/manual/"*x*"/index.md", doctype="github")
end

# Case studies

case_dir = "test/casestudies/"
cases = readdir(case_dir)
valid_cases = filter(f -> contains(f, "_source.jl"), cases)

for case in joinpath.(case_dir, valid_cases)
    println(case)
    x = last(split(case, "test/casestudies/"))
    x = first(split(x, "_source.jl"))
    println(x)
    weave(case, out_path="docs/casestudies/"*x*"/index.md", doctype="github")
end
