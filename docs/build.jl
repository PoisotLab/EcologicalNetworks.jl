using Weave
include("../src/EcologicalNetwork.jl")

for folder in ["pages/_manual", "pages/_usecases"]
    files = readdir(joinpath("docs",folder))
    documents = filter(f -> endswith(f, ".Jmd"), files)
    for doc in documents
        mtime_source = stat(joinpath("docs", folder, doc)).mtime
        destination = joinpath("docs", folder, replace(doc, ".Jmd", ".md"))
        if !isfile(destination)
            info("$(folder)/$(replace(doc, ".Jmd", ""))\tcreated, compiling")
            weave(joinpath("docs", folder, doc), out_path=joinpath("docs",folder), doctype="github")
        else
            mtime_destination = stat(destination).mtime
            if mtime_source >= mtime_destination
                info("$(folder)/$(replace(doc, ".Jmd", ""))\tchanged, compiling")
                weave(joinpath("docs", folder, doc), out_path=joinpath("docs",folder), doctype="github")
            else
                info("$(folder)/$(replace(doc, ".Jmd", ""))\tunchanged, skipping")
            end
        end
    end
end
