function nz_stream_foodweb()
  data_path = joinpath(@__DIR__, "../..", "data", "nz_stream")
  files = readdir(data_path)
  documents = filter(f -> endswith(f, ".csv"), files)
  Ns = UnipartiteNetwork{String}[]
  for doc in documents
    println(doc)
    content = readdlm(joinpath(@__DIR__, "../..", "data", "nz_stream", doc), ',')
    species_names = convert(Array{String}, content[:,1][2:end])
    interaction_matrix = map(Int64, content[2:end,2:end]).>0
    push!(Ns, UnipartiteNetwork(interaction_matrix', species_names))
  end
  return Ns
end

function web_of_life(name)
  fullname = name * ".csv"
  data_path = joinpath(@__DIR__, "../..", "data", "weboflife")
  files = readdir(data_path)
  @assert fullname in files
  content = readdlm(joinpath(@__DIR__, "../..", "data", "weboflife", fullname), ',')
  top_species_names = convert(Array{String}, vec(content[:,1][2:end]))
  bottom_species_names = convert(Array{String}, vec(content[1,:][2:end]))
  interaction_matrix = map(Int64, content[2:end,2:end])
  ntype = BipartiteQuantitativeNetwork
  if maximum(interaction_matrix) == 1
    interaction_matrix = interaction_matrix .> 0
    ntype = BipartiteNetwork
  end
  ntype(interaction_matrix, top_species_names, bottom_species_names)
end

function web_of_life()
  wol_ref = joinpath(@__DIR__, "../..", "data", "weboflife", "references.csv")
  wol_infos = readdlm(wol_ref, ',')
  names = Symbol.(replace.(wol_infos[1,:], " ", "_"))
  infos = [NamedTuples.make_tuple(names)(wol_infos[i,:]...) for i in 2:size(wol_infos,1)]
  return infos
end
