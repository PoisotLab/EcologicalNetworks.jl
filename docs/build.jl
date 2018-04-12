using Weave

case_dir = "test/casestudies/"
cases = readdir(case_dir)
valid_cases = filter(f -> contains(f, "_source.jl"), cases)

include("../src/EcologicalNetwork.jl")

for case in joinpath.(case_dir, valid_cases)
    for doctype in ["pandoc2pdf", "github"]
        weave(case, out_path="manual/pages", doctype=doctype)
    end
end
