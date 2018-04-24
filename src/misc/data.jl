function thompson_townsend_catlins()
  n_path = joinpath(@__DIR__, "../..", "data", "catlins.csv")
  content = readdlm(n_path, ';')
  species_names = convert(Array{String}, content[:,1][2:end])
  interaction_matrix = map(Int64, content[2:end,2:end]).>0
  interaction_matrix = convert(Array{Bool,2}, interaction_matrix)
  UnipartiteNetwork(interaction_matrix', species_names)
end

function fonseca_ganade_1996()
  n_path = joinpath(@__DIR__, "../..", "data", "fonseca_ganade_1996.csv")
  content = readdlm(n_path, ';')
  top_species_names = convert(Array{String}, vec(content[:,1][2:end]))
  bottom_species_names = convert(Array{String}, vec(content[1,:][2:end]))
  interaction_matrix = map(Int64, content[2:end,2:end])
  BipartiteQuantitativeNetwork(interaction_matrix, top_species_names, bottom_species_names)
end

function trojelsgaard_et_al_2014()
  site_id = ["Site"*string(s) for s in 1:14]
  data_path = joinpath(@__DIR__, "../..", "data", "trojelsgaard")
  files = readdir(data_path)
  documents = filter(f -> endswith(f, ".csv"), files)
  Ns = BipartiteQuantitativeNetwork{Int64,String}[]
  for s in site_id
    this_file = first(filter(f -> startswith(f, s), documents))
    content = readdlm(joinpath(@__DIR__, "../..", "data", "trojelsgaard", this_file), ',')
    top_species_names = convert(Array{String}, vec(content[:,1][2:end]))
    bottom_species_names = convert(Array{String}, vec(content[1,:]))[1:(end-1)]
    interaction_matrix = map(Int64, content[2:end,2:end])
    push!(Ns, BipartiteQuantitativeNetwork(interaction_matrix, top_species_names, bottom_species_names))
  end
  return Ns
end
