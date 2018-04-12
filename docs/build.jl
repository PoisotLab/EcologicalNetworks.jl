using Weave

case_dir = "test/casestudies/"
cases = readdir(case_dir)
valid_cases = filter(f -> contains(f, "_source.jl"), cases)

include("../src/EcologicalNetwork.jl")

for case in joinpath.(case_dir, valid_cases)
    println(case)
    x = last(split(case, "test/casestudies/"))
    x = first(split(x, "_source.jl"))
    println(x)
    weave(case, out_path="docs/casestudies/"*x*"/index.md", doctype="github")
end
