using Weave

include("../src/EcologicalNetwork.jl")

for folder in ["manual", "casestudies"]
    files = readdir(joinpath("docs",folder))
    documents = filter(f -> endswith(f, ".Jmd"), files)
    for doc in documents
        weave(joinpath("docs", folder, doc), out_path=joinpath("docs",folder), doctype="github")
    end
end
